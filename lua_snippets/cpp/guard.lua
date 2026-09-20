local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local function get_capture_str(parent)
  local caps = (parent and parent.captures)
    or (parent and parent.snippet and parent.snippet.captures)
    or {}
  if type(caps) == "string" then return caps end
  local c = caps[1]
  if type(c) == "table" then c = c[1] end
  return tostring(c or "")
end
local function get_visual(parent)
  local env = (parent and parent.env)
    or (parent and parent.snippet and parent.snippet.env)
    or {}
  local v = env.LS_SELECT_RAW or ""
  if type(v) == "table" then v = table.concat(v, "\n") end
  return v or ""
end
local function fqn_to_guard(fqn)
  local s = table.concat(fqn, "_")
  s = s:gsub("[.-]", "_")
  return ("_" .. s .. "_"):upper()
end
local function fqn_to_classname(fqn)
  local classname = fqn[#fqn] or ""
  classname = classname:gsub("%.[^.]*$", "")
  classname = classname:gsub("(^|_)([^_])", function(_, c)
    return c:upper()
  end)
  return classname
end
local function relpath(p, base)
  local function sp(x)
    local t = vim.split(vim.fn.fnamemodify(x, ":p"), "/", {plain=true})
    while #t > 0 and t[#t] == "" do table.remove(t) end
    return t
  end
  local a = sp(p)
  local b = sp(base)
  while #a > 0 and #b > 0 and a[1] == b[1] do
    table.remove(a, 1)
    table.remove(b, 1)
  end
  for _ = 1, #b do table.insert(a, 1, "..") end
  return table.concat(a, "/")
end
local function path_to_fqn(relp, base, depth, vtext)
  depth = depth or -1
  if base and base ~= "" then relp = relpath(relp, base) end
  local ret = {}
  if vtext and vtext ~= "" then
    for v in vim.gsplit(vtext, "[::/\\]", {plain=false}) do
      if v ~= "" then ret[#ret + 1] = v end
    end
  end
  if relp ~= "" then
    local paths = {}
    for _, x in ipairs(vim.split(relp, "/", {plain=true})) do
      if x ~= "src" and x ~= "" then paths[#paths + 1] = x end
    end
    local start = #paths - depth - 1
    if depth < 0 or start < 0 then start = 0 end
    for i = start + 1, #paths do ret[#ret + 1] = paths[i] end
  end
  return ret
end
local function header_fqn(path, depth, vtext)
  depth = tonumber(depth) or 0
  local abspath = vim.fn.fnamemodify(path, ":p")
  local parent = vim.fn.fnamemodify(abspath, ":h")
  while parent ~= "" and parent ~= "/" do
    local b = vim.fn.fnamemodify(parent, ":t")
    if b == "include" or b == "lib" or b == "libs" or b == "3rd" then
      return path_to_fqn(abspath, parent, nil, vtext)
    end
    local new_parent = vim.fn.fnamemodify(parent, ":h")
    if new_parent == parent then break end
    parent = new_parent
  end
  return path_to_fqn(abspath, "", depth, vtext)
end
local function find_header(path_, filename, recursive)
  path_ = vim.fn.fnamemodify(path_, ":p")
  local root_name = filename:gsub("%.[^.]*$", "")
  for _, ext in ipairs({".h", ".hpp", ".hh"}) do
    local header = root_name .. ext
    local pathname
    if recursive then pathname = path_ .. "/**/" .. header
    else pathname = path_ .. "/" .. header end
    local result = vim.fn.glob(pathname, false, true, false)
    if #result > 0 then return result end
  end
  return {}
end
local function rank(lhs, rhs)
  if #lhs == 0 then return 0 end
  for i = 1, #rhs do
    if lhs[1] == rhs[i] then
      local l = {}
      for j = 2, #lhs do l[#l + 1] = lhs[j] end
      local r1 = {}
      for j = i + 1, #rhs do r1[#r1 + 1] = rhs[j] end
      return math.max(1 + rank(l, r1), rank(l, rhs))
    end
  end
  local l = {}
  for j = 2, #lhs do l[#l + 1] = lhs[j] end
  return rank(l, rhs)
end
local function rank_file(lpath, rpath)
  local lhs = vim.split(lpath, "/", {plain=true})
  local rhs = vim.split(rpath, "/", {plain=true})
  return math.max(rank(lhs, rhs), rank(rhs, lhs))
end
local function best_match(src_file, headers)
  table.sort(headers, function(a, b)
    local ra = rank_file(src_file, a)
    local rb = rank_file(src_file, b)
    if ra ~= rb then return ra > rb end
    return #a < #b
  end)
  return headers[1]
end
local function source_fqn(src_file, depth, vtext)
  depth = tonumber(depth) or 0
  src_file = vim.fn.fnamemodify(src_file, ":p")
  local parent = vim.fn.fnamemodify(src_file, ":h")
  local filename = vim.fn.fnamemodify(src_file, ":t")
  local headers = find_header(parent, filename)
  if #headers > 0 then return header_fqn(headers[1], nil, vtext) end
  local include_path = ""
  while parent ~= "" and parent ~= "/" do
    local b = vim.fn.fnamemodify(parent, ":t")
    if b == "lib" or b == "libs" or b == "3rd" then
      include_path = parent
      break
    end
    if vim.fn.isdirectory(parent .. "/include") == 1 then
      include_path = parent .. "/include"
      break
    end
    local new_parent = vim.fn.fnamemodify(parent, ":h")
    if new_parent == parent then break end
    parent = new_parent
  end
  if include_path ~= "" then
    headers = find_header(include_path, filename, true)
    if #headers > 0 then
      local header = best_match(src_file, headers)
      return path_to_fqn(header, include_path, depth, vtext)
    elseif vim.fn.stridx(src_file, include_path) == 0 then
      return path_to_fqn(vim.fn.fnamemodify(src_file, ":r") .. ".h", include_path, depth, vtext)
    end
  end
  return path_to_fqn(vim.fn.fnamemodify(src_file, ":r") .. ".h", "", depth, vtext)
end
local function source_include(src_file, depth, vtext)
  local sqn = source_fqn(src_file, depth, vtext)
  if #sqn > 1 then return "<" .. table.concat(sqn, "/") .. ">" end
  return '"' .. table.concat(sqn, "/") .. '"'
end
local function context(parent)
  local depth = get_capture_str(parent)
  local vtext = get_visual(parent)
  return depth, vtext
end
local function header_namespaces_open(parent)
  local depth, vtext = context(parent)
  local fqn = header_fqn(vim.fn.expand("%:p"), depth, vtext)
  if depth == "0" then return {""} end
  local lines = {""}
  for i = 1, #fqn - 1 do lines[#lines + 1] = "namespace " .. fqn[i] .. " {" end
  lines[#lines + 1] = ""
  return lines
end
local function header_namespaces_close(parent)
  local depth, vtext = context(parent)
  local fqn = header_fqn(vim.fn.expand("%:p"), depth, vtext)
  local lines = {}
  for i = #fqn - 1, 1, -1 do lines[#lines + 1] = "}  // namespace " .. fqn[i] .. " {" end
  return lines
end
local function src_namespaces_open(parent)
  local depth, vtext = context(parent)
  local fqn = source_fqn(vim.fn.expand("%:p"), depth, vtext)
  if depth == "0" then return {""} end
  local lines = {""}
  for i = 1, #fqn - 1 do lines[#lines + 1] = "namespace " .. fqn[i] .. " {" end
  return lines
end
local function src_namespaces_close(parent)
  local depth, vtext = context(parent)
  local fqn = source_fqn(vim.fn.expand("%:p"), depth, vtext)
  local lines = {}
  for i = #fqn - 1, 1, -1 do lines[#lines + 1] = "}  // namespace " .. fqn[i] end
  return lines
end

return {

  -- header(\d*) header for include/*, header2 for 2 level dirs
  s({ trig = [[header(%d*)]], regTrig = true, desc = [[header for include/*, header2 for 2 level dirs]] }, fmt([[
/**
 * @file
 * @brief  ^x1&类的声明
 * @author ^x2&
 */
#ifndef ^x3&
#define ^x4&
^x5&
/**
 * @brief ^1&
 */
class ^x6&
{
public:
    ^0&
};
^x7&
#endif  // ^x8&

]], {
  x1 = f(function(_, parent) local d, v = context(parent) return fqn_to_classname(header_fqn(vim.fn.expand("%:p"), d, v)) end),
  x2 = f(function() return vim.env.USER or "" end),
  x3 = f(function(_, parent) local d, v = context(parent) return fqn_to_guard(header_fqn(vim.fn.expand("%:p"), d, v)) end),
  x4 = f(function(_, parent) local d, v = context(parent) return fqn_to_guard(header_fqn(vim.fn.expand("%:p"), d, v)) end),
  x5 = f(function(_, parent) return header_namespaces_open(parent) end),
  [1] = i(1),
  x6 = f(function(_, parent) local d, v = context(parent) return fqn_to_classname(header_fqn(vim.fn.expand("%:p"), d, v)) end),
  [0] = i(0),
  x7 = f(function(_, parent) return header_namespaces_close(parent) end),
  x8 = f(function(_, parent) local d, v = context(parent) return fqn_to_guard(header_fqn(vim.fn.expand("%:p"), d, v)) end),
}, { delimiters = "^&", repeat_duplicates = true })),
  -- src(\d*) src for src/*, src2 for 2 level dirs
  s({ trig = [[src(%d*)]], regTrig = true, desc = [[src for src/*, src2 for 2 level dirs]] }, fmt([[
/**
 * @file
 * @brief  ^x1&类的定义
 * @author ^x2&
 */
#include ^x3&
^x4&

^0&
^x5&

]], {
  x1 = f(function(_, parent) local d, v = context(parent) return fqn_to_classname(source_fqn(vim.fn.expand("%:p"), d, v)) end),
  x2 = f(function() return vim.env.USER or "" end),
  x3 = f(function(_, parent) local d, v = context(parent) return source_include(vim.fn.expand("%:p"), d, v) end),
  x4 = f(function(_, parent) return src_namespaces_open(parent) end),
  [0] = i(0),
  x5 = f(function(_, parent) return src_namespaces_close(parent) end),
}, { delimiters = "^&", repeat_duplicates = true })),

}
