local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- temp Tempfile
  s({ trig = [[temp]], desc = [[Tempfile]] }, fmt([[
@1?="$(mktemp -t --suffix=@2? @3?.XXXXXX)"
@x1?@4?@x2?@x3?@5?@x4?@x5?@6?@x6?


]], {
  [1] = i(1, "TMPFILE"),
  [2] = i(2, ".SUFFIX"),
  [3] = d(3, function(args, parent)
    local function __dyn_val()
            local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
            if s == "" then return "untitled" end
            return s
    end
    return sn(nil, { i(3, __dyn_val()) })
  end),
  x1 = f(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {4}),
  [4] = d(4, function(args, parent) return sn(nil, { i(4, "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'") }) end, {1}),
  x2 = f(function(args) return vim.split((args[1][1] or ""):gsub("(.+)", "\" 0               # EXIT\n"), "\n", {plain=true}) end, {4}),
  x3 = f(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {5}),
  [5] = d(5, function(args, parent) return sn(nil, { i(5, "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1") }) end, {1}),
  x4 = f(function(args) return vim.split((args[1][1] or ""):gsub("(.+)", "\" 2       # INT\n"), "\n", {plain=true}) end, {5}),
  x5 = f(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {6}),
  [6] = d(6, function(args, parent) return sn(nil, { i(6, "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1") }) end, {1}),
  x6 = f(function(args) return vim.split((args[1][1] or ""):gsub("(.+)", "\" 1 15    # HUP TERM\n"), "\n", {plain=true}) end, {6}),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- temp TempDir
  s({ trig = [[temp]], desc = [[TempDir]] }, fmt([[
@1?="$(mktemp -d @2?.XXXXXX)"
trap "rm -rf '$@1?'" 0               # EXIT
trap "rm -rf '$@1?'; exit 1" 2       # INT
trap "rm -rf '$@1?'; exit 1" 1 15    # HUP TERM
@0?

]], {
  [1] = i(1, "TMPDIR"),
  [2] = d(2, function(args, parent)
    local function __dyn_val()
            local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
            if s == "" then return "untitled" end
            return s
    end
    return sn(nil, { i(2, __dyn_val()) })
  end),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),
  -- plugin dotfiles plugin bootstrap.sh
  s({ trig = [[plugin]], desc = [[dotfiles plugin bootstrap.sh]] }, fmt([[
source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/util.sh"
init_plugin "@1?"
@2?_file="$(create_plugin_file @3?)"
@0?

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")) }) end),
  [2] = i(2, "env"),
  [3] = d(3, function(args, parent) return sn(nil, { i(3, (function(args) return args[1][1] or "" end)({args[1]}) .. ".sh") }) end, {2}),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),

}
