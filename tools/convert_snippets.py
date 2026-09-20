#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Convert UltiSnips snippets to VS Code JSON / LuaSnip Lua.

- Static snippets (pure text + tabstops + mappable strftime + ${VISUAL})
  -> vscode_snippets/<name>.json  (VS Code format)
- Dynamic snippets (`!p` python, `!v` vimscript not mappable to VS Code)
  -> lua_snippets/<name>.lua      (LuaSnip format)

LuaSnip output notes:
- tabstops are renumbered contiguously (LuaSnip requires non-gapped
  insert-node positions; the `insert_nodes` linking breaks on gaps).
- `${N:default}` with a simple text default becomes `i(N, "default")`.
- nested placeholders / `$M` mirrors inside defaults are flattened.
"""
import os
import re
import json

BASE = os.path.dirname(os.path.abspath(__file__))
ULTI_DIR = os.path.join(BASE, "UltiSnips")
VSC_DIR = os.path.join(BASE, "vscode_snippets")
LUA_DIR = os.path.join(BASE, "lua_snippets")

STRFTIME_MAP = {
    "%Y%m%d": "$CURRENT_YEAR$CURRENT_MONTH$CURRENT_DATE",
    "%Y-%m-%d": "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
    "%Y-%m-%d %A": "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_DAY_NAME",
    "%Y-%m-%d %H:%M:%S": "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND",
    "%y%m%d": "$CURRENT_YEAR_SHORT$CURRENT_MONTH$CURRENT_DATE",
    "%H:%M": "$CURRENT_HOUR:$CURRENT_MINUTE",
    "%H:%M:%S": "$CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND",
}

VIM_FN_MAP = [
    ("expand", "vim.fn.expand"),
    ("substitute", "vim.fn.substitute"),
    ("fnamemodify", "vim.fn.fnamemodify"),
    ("findfile", "vim.fn.findfile"),
    ("strftime", "os.date"),
    ("localtime", "os.time"),
]

MIRROR_FN = 'function(args) return args[1][1] or "" end'

# ---------------------------------------------------------------- parsing --

SNIPPET_RE = re.compile(
    r"^snippet[ \t]+(?P<trigger>\"(?:[^\"\\]|\\.)*\"|\S+)(?:[ \t]+\"(?P<description>(?:[^\"\\]|\\.)*)\")?(?:[ \t]+(?P<options>\S+))?[ \t]*\n(?P<body>.*?)^endsnippet$",
    re.MULTILINE | re.DOTALL,
)


def parse_snippets(content):
    out = []
    for m in SNIPPET_RE.finditer(content):
        trigger = m.group("trigger")
        if trigger.startswith('"'):
            trigger = trigger[1:-1]
        desc = m.group("description")
        if desc is not None:
            desc = desc.replace('\\"', '"').replace("\\\\", "\\")
        out.append({
            "trigger": trigger,
            "description": desc or "",
            "options": m.group("options") or "",
            "body": m.group("body"),
        })
    return out


# ------------------------------------------------------------ classifying --

def is_dynamic(body):
    if re.search(r"`!p", body):
        return True
    for script in re.findall(r"`!v\s*(.*?)`", body, re.S):
        fm = re.match(r'strftime\("(?P<fmt>[^"]*)"\)$', script.strip())
        if fm and fm.group("fmt") in STRFTIME_MAP:
            continue
        return True
    return False


# ------------------------------------------------- static -> VS Code JSON --

def vscode_process_line(line):
    def repl_strftime(m):
        script = m.group(1).strip()
        fm = re.match(r'strftime\("(?P<fmt>[^"]*)"\)$', script)
        if fm and fm.group("fmt") in STRFTIME_MAP:
            return STRFTIME_MAP[fm.group("fmt")]
        return m.group(0)

    line = re.sub(r"`!v\s*(.*?)`", repl_strftime, line)
    line = re.sub(r"\$\{VISUAL\}", "$TM_SELECTED_TEXT", line)
    return line


def to_vscode(snip):
    body_lines = snip["body"].split("\n")
    if body_lines and body_lines[-1] == "":
        body_lines = body_lines[:-1]
    return {
        "prefix": snip["trigger"],
        "body": [vscode_process_line(l) for l in body_lines],
        "description": snip["description"] or snip["trigger"],
    }


def unique_key(key, used):
    if key not in used:
        used.add(key)
        return key
    n = 2
    while f"{key}_{n}" in used:
        n += 1
    used.add(f"{key}_{n}")
    return f"{key}_{n}"


# ------------------------------------------------------- dynamic -> LuaSnip --

def lua_long(s):
    level = 0
    while True:
        eq = "=" * level
        op = "[" + eq + "["
        cl = "]" + eq + "]"
        emb = op + s + cl
        pos = emb.find(cl, len(op))
        if pos == len(op) + len(s):
            return emb
        level += 1


def lua_string(s):
    s = s.replace("\\", "\\\\")
    s = s.replace('"', '\\"')
    s = s.replace("\n", "\\n")
    return '"' + s + '"'


def vim_regex_to_lua(pat):
    return (
        pat.replace("\\s", "%s")
        .replace("\\d", "%d")
        .replace("\\w", "%w")
        .replace("\\a", "%a")
        .replace("\\.", ".")
        .replace("\\*", "*")
        .replace("\\+", "+")
    )


def translate_vim_expr(expr):
    out = []
    i, n = 0, len(expr)
    while i < n:
        c = expr[i]
        if c == '"':
            j = i + 1
            while j < n:
                if expr[j] == "\\":
                    j += 2
                    continue
                if expr[j] == '"':
                    break
                j += 1
            out.append(expr[i:j + 1])
            i = j + 1
            continue
        if c == ".":
            out.append("..")
            i += 1
            continue
        matched = False
        for name, repl in VIM_FN_MAP:
            if expr.startswith(name, i):
                after = expr[i + len(name):].lstrip()
                if after.startswith("("):
                    out.append(repl)
                    i += len(name)
                    matched = True
                    break
        if matched:
            continue
        out.append(c)
        i += 1
    return "".join(out)


def python_script_to_fn(script):
    """Return (fn_code, args) where args is None | int | (int, int)."""
    s = script.strip()
    if "re.sub(r'\\.[^.]*$', '', snip.fn)" in s:
        return ("function() return vim.fn.expand(\"%:t:r\") end", None)
    if "re.sub(r'[^a-zA-Z]', '_', snip.fn)" in s:
        return (
            "function()\n"
            "      local s = vim.fn.expand(\"%:t\"):gsub(\"[^%a]\", \"_\")\n"
            "      if s == \"\" then return \"untitled\" end\n"
            "      return s\n"
            "    end",
            None,
        )
    m = re.search(r"re\.sub\(\"\[,']\+\",\s*\"\",\s*t\[(\d+)\]\)", s)
    if m:
        return ("function(args) return (args[1][1] or \"\"):gsub(\"[,']+\", \"\") end", int(m.group(1)))
    m = re.search(r"t\[(\d+)\]\s+if\s+t\[\1\]\s+else\s+t\[(\d+)\]", s)
    if m:
        return (
            "function(args)\n"
            "      local a = args[1][1] or \"\"\n"
            "      if a ~= \"\" then return a end\n"
            "      return args[2][1] or \"\"\n"
            "    end",
            (int(m.group(1)), int(m.group(2))),
        )
    if "uuid.uuid4()" in s:
        return ("function() return uuid4() end", None)
    if "snip.fn.split('-')" in s or 'snip.fn.split("-")' in s:
        return (
            "function()\n"
            "      local p = vim.split(vim.fn.expand(\"%:t\"), \"-\", {plain=true})\n"
            "      if #p >= 3 then return table.concat({p[1], p[2], p[3]}, \"/\") end\n"
            "      return \"\"\n"
            "    end",
            None,
        )
    if "os.path.basename(os.path.dirname(os.path.abspath(path)))" in s:
        return ("function() return vim.fn.fnamemodify(vim.fn.expand(\"%:p\"), \":h:t\") end", None)
    # --- cpp_guard helpers (see EXTRA_LUA_HEADER["cpp_guard"]) ---
    if "fqn_to_classname(header_fqn" in s:
        return ("function(_, parent) local d, v = context(parent) return fqn_to_classname(header_fqn(vim.fn.expand(\"%:p\"), d, v)) end", None)
    if "fqn_to_guard(header_fqn" in s:
        return ("function(_, parent) local d, v = context(parent) return fqn_to_guard(header_fqn(vim.fn.expand(\"%:p\"), d, v)) end", None)
    if "fqn_to_classname(source_fqn" in s:
        return ("function(_, parent) local d, v = context(parent) return fqn_to_classname(source_fqn(vim.fn.expand(\"%:p\"), d, v)) end", None)
    if "source_include(path" in s:
        return ("function(_, parent) local d, v = context(parent) return source_include(vim.fn.expand(\"%:p\"), d, v) end", None)
    if "reversed(header_fqn" in s:
        return ("function(_, parent) return header_namespaces_close(parent) end", None)
    if "reversed(source_fqn" in s:
        return ("function(_, parent) return src_namespaces_close(parent) end", None)
    if "for n in header_fqn" in s:
        return ("function(_, parent) return header_namespaces_open(parent) end", None)
    if "for n in source_fqn" in s:
        return ("function(_, parent) return src_namespaces_open(parent) end", None)
    return ("function() return \"TODO(convert): \" .. %s end" % lua_string(s), None)


def script_to_fn(script, kind):
    """Return (fn_code, args)."""
    if kind == "v":
        s = script.strip()
        if s == "$USER":
            return ("function() return vim.env.USER or \"\" end", None)
        m = re.match(r'strftime\("(?P<fmt>[^"]*)"\)\s*(?:,\s*(?P<arg>.*?))?$', s)
        if m:
            fmt = m.group("fmt").replace("\\", "\\\\")
            if m.group("arg"):
                arg = translate_vim_expr(m.group("arg"))
                return ('function() return os.date("%s", %s) end' % (fmt, arg), None)
            return ('function() return os.date("%s") end' % fmt, None)
        return ("function() return %s end" % translate_vim_expr(s), None)
    return python_script_to_fn(script)


def transform_node(idx, pat, repl):
    repl = repl.replace("\\n", "\n")
    lpat = lua_string(vim_regex_to_lua(pat))
    lrepl = lua_string(repl)
    if "\n" in repl:
        fn = (
            "function(args) return vim.split((args[1][1] or \"\"):gsub(%s, %s), \"\\n\", {plain=true}) end"
        )
    else:
        fn = "function(args) return (args[1][1] or \"\"):gsub(%s, %s) end"
    return (fn % (lpat, lrepl), idx)


def visual_fn(default=None):
    if default:
        return (
            "function(_, parent)\n"
            "      local sel = parent and (parent.snippet and parent.snippet.env or parent.env) and "
            "(parent.snippet and parent.snippet.env or parent.env).LS_SELECT_RAW\n"
            "      if type(sel) == \"table\" then\n"
            "        local txt = table.concat(sel, \"\\n\")\n"
            "        if txt ~= \"\" then return sel end\n"
            "      elseif type(sel) == \"string\" then\n"
            "        if sel ~= \"\" then return {sel} end\n"
            "      end\n"
            '      return {"%s"}\n'
            "    end" % default.replace('"', '\\"')
        )
    return (
        "function(_, parent)\n"
        "      local sel = parent and (parent.snippet and parent.snippet.env or parent.env) and "
        "(parent.snippet and parent.snippet.env or parent.env).LS_SELECT_RAW\n"
        "      if type(sel) == \"table\" then return sel end\n"
        "      if type(sel) == \"string\" and sel ~= \"\" then return {sel} end\n"
        '      return {""}\n'
        "    end"
    )


SCRIPT_SENT = re.compile(r"\x00SCRIPT(\d+)\x00")


def find_placeholder_close(line, start):
    depth = 1
    j = start + 2
    n = len(line)
    while j < n:
        c = line[j]
        if c == "`":
            close_b = line.find("`", j + 1)
            j = close_b + 1 if close_b != -1 else n
            continue
        if line[j:j + 2] == "${":
            depth += 1
            j += 2
            continue
        if c == "}":
            depth -= 1
            if depth == 0:
                return j
        j += 1
    return start + 2


def tokenize_line(line, scripts, seen):
    """Return a flat list of node tuples.

    Node tuples:
      ("t", text)
      ("i", pos, init)  init: None | ("str", text) | ("f", fn, args)
      ("f", fn, args)   args: None | int | (int, int)
    """
    out = []
    textbuf = []

    def flush():
        if textbuf:
            s = "".join(textbuf)
            if s:
                out.append(("t", s))
            del textbuf[:]

    i, n = 0, len(line)
    while i < n:
        c = line[i]
        if c == "\\" and i + 1 < n and line[i + 1] in ("$", "`", "\\"):
            textbuf.append(line[i + 1])
            i += 2
            continue
        m = SCRIPT_SENT.match(line, i)
        if m:
            flush()
            idx = int(m.group(1))
            script, kind = scripts[idx]
            fn, args = script_to_fn(script, kind)
            out.append(("f", fn, args))
            i = m.end()
            continue
        if c == "$" and i + 1 < n and line[i + 1] == "{":
            close = find_placeholder_close(line, i)
            inner = line[i + 2:close]
            i = close + 1
            if inner == "VISUAL":
                flush()
                out.append(("f", visual_fn(), None))
                continue
            tm = re.match(r"(\d+)/(.*)$", inner, re.S)
            if tm:
                flush()
                rest = tm.group(2).split("/")
                pat = rest[0]
                repl = rest[1] if len(rest) > 1 else ""
                out.append(("f",) + transform_node(int(tm.group(1)), pat, repl))
                continue
            mm = re.match(r"(\d+)(?::(.*))?$", inner, re.S)
            if not mm:
                flush()
                out.append(("t", "${" + inner + "}"))
                continue
            idx = int(mm.group(1))
            default = mm.group(2)
            flush()
            if default is None:
                out.extend(insert_or_mirror(idx, None, scripts, seen))
            else:
                out.extend(insert_or_mirror(idx, default, scripts, seen))
            continue
        if c == "$" and i + 1 < n and line[i + 1].isdigit():
            flush()
            idx = int(line[i + 1])
            out.extend(insert_or_mirror(idx, None, scripts, seen))
            i += 2
            continue
        textbuf.append(c)
        i += 1
    flush()
    return out


def extract_fn_body(fn):
    m = re.match(r"function\([^)]*\)\s*(.*?)\s*end\s*$", fn, re.S)
    return m.group(1) if m else fn


def concat_fn(subs):
    """Build (fn, refs) that concatenates sub-node values."""
    parts = []
    refs = []
    for sub in subs:
        if sub[0] == "t":
            parts.append(lua_string(sub[1]))
        else:
            subargs = sub[2]
            arglist = subargs if isinstance(subargs, tuple) else (subargs,)
            start = len(refs)
            for a in arglist:
                refs.append(a)
            body = extract_fn_body(sub[1])
            calls = ", ".join("args[%d]" % (start + k + 1) for k in range(len(arglist)))
            parts.append("(function(args) %s end)({%s})" % (body, calls))
    if not parts:
        return 'function() return "" end', None
    fn = "function(args) return %s end" % " .. ".join(parts)
    if not refs:
        return fn, None
    return fn, (tuple(refs) if len(refs) > 1 else refs[0])


def insert_or_mirror(idx, default, scripts, seen):
    """Return a list of node tuples (flat, no snippet_nodes)."""
    if idx in seen:
        return [("f", MIRROR_FN, idx)]
    seen.add(idx)
    if default is None:
        return [("i", idx, None)]

    m = SCRIPT_SENT.fullmatch(default)
    if m:
        script, kind = scripts[int(m.group(1))]
        fn, args = script_to_fn(script, kind)
        return [("i", idx, ("f", fn, args))]

    if "${VISUAL" in default:
        parts = re.split(r"\$\{VISUAL:([^}]*)\}", default)
        subs = []
        for k in range(0, len(parts), 2):
            subs.extend(tokenize_line(parts[k], scripts, seen))
            if k + 1 < len(parts):
                subs.append(("f", visual_fn(parts[k + 1]), None))
        if len(subs) == 1 and subs[0][0] == "f":
            return [("i", idx, ("f", subs[0][1], subs[0][2]))]
        fn, refs = concat_fn(subs)
        return [("i", idx, ("f", fn, refs))]

    if not re.search(r"[\\$\x00]", default):
        return [("i", idx, ("str", default))]

    subs = tokenize_line(default, scripts, seen)
    if len(subs) == 1 and subs[0][0] == "f":
        return [("i", idx, ("f", subs[0][1], subs[0][2]))]
    if len(subs) == 1 and subs[0][0] == "t":
        return [("i", idx, ("str", subs[0][1]))]
    if any(s[0] == "i" for s in subs):
        return subs
    fn, refs = concat_fn(subs)
    return [("i", idx, ("f", fn, refs))]


LUA_HEADER = [
    "local ls = require(\"luasnip\")",
    "local s = ls.snippet",
    "local t = ls.text_node",
    "local i = ls.insert_node",
    "local f = ls.function_node",
    "local d = ls.dynamic_node",
    "local sn = ls.snippet_node",
    "local fmt = require(\"luasnip.extras.fmt\").fmt",
]

EXTRA_LUA_HEADER = {
    "markdown_jekyll": [
        "local function uuid4()",
        "  math.randomseed(os.time() * 1000 + (vim.fn.getpid() or 0))",
        '  return (string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)',
        "    local v = c == \"x\" and math.random(0, 15) or math.random(8, 11)",
        '    return string.format("%x", v)',
        "  end))",
        "end",
    ],
    "cpp_guard": [
        "local function get_capture_str(parent)",
        "  local caps = (parent and parent.captures)",
        "    or (parent and parent.snippet and parent.snippet.captures)",
        "    or {}",
        '  if type(caps) == "string" then return caps end',
        "  local c = caps[1]",
        '  if type(c) == "table" then c = c[1] end',
        '  return tostring(c or "")',
        "end",
        "local function get_visual(parent)",
        "  local env = (parent and parent.env)",
        "    or (parent and parent.snippet and parent.snippet.env)",
        "    or {}",
        "  local v = env.LS_SELECT_RAW or \"\"",
        '  if type(v) == "table" then v = table.concat(v, "\\n") end',
        '  return v or ""',
        "end",
        "local function fqn_to_guard(fqn)",
        '  local s = table.concat(fqn, "_")',
        '  s = s:gsub("[.-]", "_")',
        '  return ("_" .. s .. "_"):upper()',
        "end",
        "local function fqn_to_classname(fqn)",
        '  local classname = fqn[#fqn] or ""',
        '  classname = classname:gsub("%.[^.]*$", "")',
        "  classname = classname:gsub(\"(^|_)([^_])\", function(_, c)",
        "    return c:upper()",
        "  end)",
        "  return classname",
        "end",
        "local function relpath(p, base)",
        "  local function sp(x)",
        "    local t = vim.split(vim.fn.fnamemodify(x, \":p\"), \"/\", {plain=true})",
        '    while #t > 0 and t[#t] == "" do table.remove(t) end',
        "    return t",
        "  end",
        "  local a = sp(p)",
        "  local b = sp(base)",
        '  while #a > 0 and #b > 0 and a[1] == b[1] do',
        "    table.remove(a, 1)",
        "    table.remove(b, 1)",
        "  end",
        '  for _ = 1, #b do table.insert(a, 1, "..") end',
        '  return table.concat(a, "/")',
        "end",
        "local function path_to_fqn(relp, base, depth, vtext)",
        "  depth = depth or -1",
        '  if base and base ~= "" then relp = relpath(relp, base) end',
        "  local ret = {}",
        '  if vtext and vtext ~= "" then',
        '    for v in vim.gsplit(vtext, "[::/\\\\]", {plain=false}) do',
        '      if v ~= "" then ret[#ret + 1] = v end',
        "    end",
        "  end",
        '  if relp ~= "" then',
        '    local paths = {}',
        '    for _, x in ipairs(vim.split(relp, "/", {plain=true})) do',
        '      if x ~= "src" and x ~= "" then paths[#paths + 1] = x end',
        "    end",
        "    local start = #paths - depth - 1",
        '    if depth < 0 or start < 0 then start = 0 end',
        "    for i = start + 1, #paths do ret[#ret + 1] = paths[i] end",
        "  end",
        "  return ret",
        "end",
        "local function header_fqn(path, depth, vtext)",
        "  depth = tonumber(depth) or 0",
        '  local abspath = vim.fn.fnamemodify(path, ":p")',
        '  local parent = vim.fn.fnamemodify(abspath, ":h")',
        '  while parent ~= "" and parent ~= "/" do',
        '    local b = vim.fn.fnamemodify(parent, ":t")',
        '    if b == "include" or b == "lib" or b == "libs" or b == "3rd" then',
        "      return path_to_fqn(abspath, parent, nil, vtext)",
        "    end",
        '    local new_parent = vim.fn.fnamemodify(parent, ":h")',
        "    if new_parent == parent then break end",
        "    parent = new_parent",
        "  end",
        '  return path_to_fqn(abspath, "", depth, vtext)',
        "end",
        "local function find_header(path_, filename, recursive)",
        '  path_ = vim.fn.fnamemodify(path_, ":p")',
        '  local root_name = filename:gsub("%.[^.]*$", "")',
        '  for _, ext in ipairs({".h", ".hpp", ".hh"}) do',
        "    local header = root_name .. ext",
        "    local pathname",
        '    if recursive then pathname = path_ .. "/**/" .. header',
        '    else pathname = path_ .. "/" .. header end',
        '    local result = vim.fn.glob(pathname, false, true, false)',
        "    if #result > 0 then return result end",
        "  end",
        "  return {}",
        "end",
        "local function rank(lhs, rhs)",
        "  if #lhs == 0 then return 0 end",
        "  for i = 1, #rhs do",
        "    if lhs[1] == rhs[i] then",
        "      local l = {}",
        "      for j = 2, #lhs do l[#l + 1] = lhs[j] end",
        "      local r1 = {}",
        "      for j = i + 1, #rhs do r1[#r1 + 1] = rhs[j] end",
        "      return math.max(1 + rank(l, r1), rank(l, rhs))",
        "    end",
        "  end",
        "  local l = {}",
        "  for j = 2, #lhs do l[#l + 1] = lhs[j] end",
        "  return rank(l, rhs)",
        "end",
        "local function rank_file(lpath, rpath)",
        '  local lhs = vim.split(lpath, "/", {plain=true})',
        '  local rhs = vim.split(rpath, "/", {plain=true})',
        "  return math.max(rank(lhs, rhs), rank(rhs, lhs))",
        "end",
        "local function best_match(src_file, headers)",
        "  table.sort(headers, function(a, b)",
        "    local ra = rank_file(src_file, a)",
        "    local rb = rank_file(src_file, b)",
        '    if ra ~= rb then return ra > rb end',
        "    return #a < #b",
        "  end)",
        "  return headers[1]",
        "end",
        "local function source_fqn(src_file, depth, vtext)",
        "  depth = tonumber(depth) or 0",
        '  src_file = vim.fn.fnamemodify(src_file, ":p")',
        '  local parent = vim.fn.fnamemodify(src_file, ":h")',
        '  local filename = vim.fn.fnamemodify(src_file, ":t")',
        "  local headers = find_header(parent, filename)",
        "  if #headers > 0 then return header_fqn(headers[1], nil, vtext) end",
        '  local include_path = ""',
        '  while parent ~= "" and parent ~= "/" do',
        '    local b = vim.fn.fnamemodify(parent, ":t")',
        '    if b == "lib" or b == "libs" or b == "3rd" then',
        "      include_path = parent",
        "      break",
        "    end",
        '    if vim.fn.isdirectory(parent .. "/include") == 1 then',
        '      include_path = parent .. "/include"',
        "      break",
        "    end",
        '    local new_parent = vim.fn.fnamemodify(parent, ":h")',
        "    if new_parent == parent then break end",
        "    parent = new_parent",
        "  end",
        '  if include_path ~= "" then',
        "    headers = find_header(include_path, filename, true)",
        "    if #headers > 0 then",
        "      local header = best_match(src_file, headers)",
        "      return path_to_fqn(header, include_path, depth, vtext)",
        '    elseif vim.fn.stridx(src_file, include_path) == 0 then',
        '      return path_to_fqn(vim.fn.fnamemodify(src_file, ":r") .. ".h", include_path, depth, vtext)',
        "    end",
        "  end",
        '  return path_to_fqn(vim.fn.fnamemodify(src_file, ":r") .. ".h", "", depth, vtext)',
        "end",
        "local function source_include(src_file, depth, vtext)",
        "  local sqn = source_fqn(src_file, depth, vtext)",
        '  if #sqn > 1 then return "<" .. table.concat(sqn, "/") .. ">" end',
        '  return \'"\' .. table.concat(sqn, "/") .. \'"\'',
        "end",
        "local function context(parent)",
        "  local depth = get_capture_str(parent)",
        "  local vtext = get_visual(parent)",
        "  return depth, vtext",
        "end",
        "local function header_namespaces_open(parent)",
        "  local depth, vtext = context(parent)",
        '  local fqn = header_fqn(vim.fn.expand("%:p"), depth, vtext)',
        '  if depth == "0" then return {""} end',
        '  local lines = {""}',
        "  for i = 1, #fqn - 1 do lines[#lines + 1] = \"namespace \" .. fqn[i] .. \" {\" end",
        '  lines[#lines + 1] = ""',
        "  return lines",
        "end",
        "local function header_namespaces_close(parent)",
        "  local depth, vtext = context(parent)",
        '  local fqn = header_fqn(vim.fn.expand("%:p"), depth, vtext)',
        "  local lines = {}",
        "  for i = #fqn - 1, 1, -1 do lines[#lines + 1] = \"}  // namespace \" .. fqn[i] .. \" {\" end",
        "  return lines",
        "end",
        "local function src_namespaces_open(parent)",
        "  local depth, vtext = context(parent)",
        '  local fqn = source_fqn(vim.fn.expand("%:p"), depth, vtext)',
        '  if depth == "0" then return {""} end',
        '  local lines = {""}',
        "  for i = 1, #fqn - 1 do lines[#lines + 1] = \"namespace \" .. fqn[i] .. \" {\" end",
        "  return lines",
        "end",
        "local function src_namespaces_close(parent)",
        "  local depth, vtext = context(parent)",
        '  local fqn = source_fqn(vim.fn.expand("%:p"), depth, vtext)',
        "  local lines = {}",
        "  for i = #fqn - 1, 1, -1 do lines[#lines + 1] = \"}  // namespace \" .. fqn[i] end",
        "  return lines",
        "end",
    ],
}


def serialize_fn(fn, args, mapping):
    if args is None:
        return "ls.function_node(%s)" % fn
    if isinstance(args, tuple):
        return "ls.function_node(%s, {%d, %d})" % (fn, mapping[args[0]], mapping[args[1]])
    return "ls.function_node(%s, {%d})" % (fn, mapping[args])


def serialize_text(s):
    if "\n" in s:
        lines = s.split("\n")
        return "ls.text_node({%s})" % ", ".join(lua_string(l) for l in lines)
    return "ls.text_node(%s)" % lua_string(s)


# ------------------------------------------------------- fmt-style emission --

def extract_fn_body(fn):
    m = re.match(r"function\([^)]*\)\s*(.*?)\s*end\s*$", fn, re.S)
    return m.group(1) if m else fn


def indent_block(s, n):
    pad = " " * n
    return "\n".join(pad + l if l.strip() else "" for l in s.split("\n"))


FMT_DELIM_CANDIDATES = ["@?", "$%", "!@", "^&", "&$", "|*"]


def pick_delims(text):
    for d in FMT_DELIM_CANDIDATES:
        if d[0] not in text and d[1] not in text:
            return d
    raise ValueError("no usable fmt delimiters for template")


def fmt_insert_code(pos, init, mapping):
    """Code for the mapping table entry of an insert with a computed default."""
    if init is None:
        return "i(%d)" % pos
    if init[0] == "str":
        return "i(%d, %s)" % (pos, lua_string(init[1]))
    fn, args = init[1], init[2]
    if args is None:
        argpart = ""
    elif isinstance(args, tuple):
        argpart = ", {%d, %d}" % (mapping[args[0]], mapping[args[1]])
    else:
        argpart = ", {%d}" % mapping[args]
    body = extract_fn_body(fn).strip()
    m = re.match(r"^return\s+(.+)$", body, re.S)
    if m and "\n" not in body:
        expr = m.group(1)
        return (
            "d(%d, function(args, parent) return sn(nil, { i(%d, %s) }) end%s)"
            % (pos, pos, expr, argpart)
        )
    return (
        "d(%d, function(args, parent)\n"
        "    local function __dyn_val()\n"
        "      %s\n"
        "    end\n"
        "    return sn(nil, { i(%d, __dyn_val()) })\n"
        "  end%s)"
    ) % (pos, indent_block(body, 6), pos, argpart)


def fmt_fn_code(fn, args, mapping):
    if args is None:
        return "f(%s)" % fn
    if isinstance(args, tuple):
        return "f(%s, {%d, %d})" % (fn, mapping[args[0]], mapping[args[1]])
    return "f(%s, {%d})" % (fn, mapping[args])


def to_luasnip(snip):
    body = snip["body"]
    scripts = []

    def script_repl(m):
        scripts.append((m.group(1).strip(), "p" if m.group(0)[:3] == "`!p" else "v"))
        return "\x00SCRIPT%d\x00" % (len(scripts) - 1)

    body = re.sub(r"`!v\s*(.*?)`", script_repl, body, flags=re.S)
    body = re.sub(r"`!p\s*(.*?)`", script_repl, body, flags=re.S)

    op, cl = pick_delims(body)
    delims = op + cl

    seen = set()
    nodes = []
    lines = body.split("\n")
    for li, line in enumerate(lines):
        nodes.extend(tokenize_line(line, scripts, seen))
        if li < len(lines) - 1:
            nodes.append(("t", "\n"))

    # renumber insert positions contiguously (LuaSnip needs non-gapped jumps).
    mapping = {}
    counter = 1
    for node in nodes:
        if node[0] == "i":
            pos = node[1]
            if pos == 0:
                mapping.setdefault(0, 0)
            elif pos not in mapping:
                mapping[pos] = counter
                counter += 1
        elif node[0] == "f" and node[2] is not None:
            for p in (node[2],) if not isinstance(node[2], tuple) else node[2]:
                if p != 0 and p not in mapping:
                    mapping[p] = counter
                    counter += 1

    # build the fmt template + mapping table.
    tpl_parts = []
    node_map = {}
    named = 0
    buf = []
    insert_positions = {n[1] for n in nodes if n[0] == "i"}

    def flush():
        if buf:
            tpl_parts.append("".join(buf))
            del buf[:]

    for node in nodes:
        if node[0] == "t":
            buf.append(node[1])
        elif node[0] == "i":
            flush()
            pos = mapping[node[1]]
            key = str(pos)
            tpl_parts.append(op + key + cl)
            node_map[key] = fmt_insert_code(pos, node[2], mapping)
        else:
            flush()
            fn, args = node[1], node[2]
            if (
                args is not None
                and not isinstance(args, tuple)
                and fn == MIRROR_FN
                and args in insert_positions
            ):
                p = mapping[args]
                tpl_parts.append(op + ("%d" % p) + cl)
            else:
                named += 1
                key = "x%d" % named
                tpl_parts.append(op + key + cl)
                node_map[key] = fmt_fn_code(fn, args, mapping)
    flush()

    tpl = "".join(tpl_parts)
    if tpl and not tpl.endswith("\n"):
        tpl += "\n"
    map_lines = []
    for key, code in node_map.items():
        if key.isdigit():
            map_lines.append("  [%s] = %s," % (key, code))
        else:
            map_lines.append("  %s = %s," % (key, code))

    options = snip["options"]
    trig = snip["trigger"]
    desc = snip["description"] or ""
    if "r" in options:
        trig_part = "{ trig = %s, regTrig = true, desc = %s }" % (
            lua_long(vim_regex_to_lua(trig)),
            lua_long(desc),
        )
    else:
        trig_part = "{ trig = %s, desc = %s }" % (lua_long(trig), lua_long(desc))

    lines_out = []
    lines_out.append("  -- %s %s" % (trig, desc))
    lines_out.append("  s(%s, fmt([[" % trig_part)
    lines_out.append(tpl)
    lines_out.append("]], {")
    lines_out.extend(map_lines)
    lines_out.append('}, { delimiters = "%s", repeat_duplicates = true })),' % delims)
    return "\n".join(lines_out)


# ------------------------------------------------------------------- main --

LUA_OVERRIDES = {
    "behave": "cucumber/behave",
    "impressjs": "html/impressjs",
    "lilypond_template": "lilypond/skel",
}
VSC_OVERRIDES = {
    "lilypond_template": "lilypond/skel",
}


def out_relpath(base, overrides):
    """underscores become subdirectories; `template` is renamed to `skel`."""
    if base in overrides:
        return overrides[base]
    parts = base.split("_")
    if len(parts) == 1:
        return base
    return parts[0] + "/" + "_".join(parts[1:])


def main():
    os.makedirs(VSC_DIR, exist_ok=True)
    os.makedirs(LUA_DIR, exist_ok=True)

    skip = {"markdown_revealjs.snippets", "markdown_tex_math.snippets"}
    handcrafted_lua = set()
    files = sorted(f for f in os.listdir(ULTI_DIR) if f.endswith(".snippets") and f not in skip)

    for fname in files:
        with open(os.path.join(ULTI_DIR, fname), encoding="utf-8") as f:
            content = f.read()
        snips = parse_snippets(content)
        if not snips:
            print("skip  (no snippets):", fname)
            continue

        base = os.path.splitext(fname)[0]
        vsc = {}
        used = set()
        lua_snips = []
        dyn = stt = 0
        for snip in snips:
            if is_dynamic(snip["body"]):
                lua_snips.append(to_luasnip(snip))
                dyn += 1
            else:
                key = unique_key(snip["trigger"], used)
                vsc[key] = to_vscode(snip)
                stt += 1

        if vsc:
            rel = out_relpath(base, VSC_OVERRIDES)
            path = os.path.join(VSC_DIR, rel + ".json")
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w", encoding="utf-8") as f:
                json.dump(vsc, f, ensure_ascii=False, indent=2)
            print("vscode (%d static): %s -> %s" % (stt, fname, path))
        if lua_snips and fname not in handcrafted_lua:
            rel = out_relpath(base, LUA_OVERRIDES)
            path = os.path.join(LUA_DIR, rel + ".lua")
            os.makedirs(os.path.dirname(path), exist_ok=True)
            header = LUA_HEADER + EXTRA_LUA_HEADER.get(base, [])
            with open(path, "w", encoding="utf-8") as f:
                f.write("\n".join(header + ["", "return {", ""] + lua_snips + ["", "}"]) + "\n")
            print("luasnip (%d dynamic): %s -> %s" % (dyn, fname, path))


if __name__ == "__main__":
    main()