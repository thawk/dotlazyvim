local ls = require("luasnip")

return {

  -- temp Tempfile
  ls.snippet({ trig = [[temp]], desc = [[Tempfile]] }, {
    ls.insert_node(1, "TMPFILE"),
    ls.text_node("=\"$(mktemp -t --suffix="),
    ls.insert_node(2, ".SUFFIX"),
    ls.text_node(" "),
    ls.insert_node(3, ls.function_node(function()
      local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
      if s == "" then return "untitled" end
      return s
    end)),
    ls.text_node({".XXXXXX)\"", ""}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {4}),
    ls.insert_node(4, ls.function_node(function(args) return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'" end, {1})),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 0               # EXIT\n") end, {4}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {5}),
    ls.insert_node(5, ls.function_node(function(args) return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1" end, {1})),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 2       # INT\n") end, {5}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {6}),
    ls.insert_node(6, ls.function_node(function(args) return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1" end, {1})),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 1 15    # HUP TERM\n") end, {6}),
    ls.text_node({"", "", ""}),
  }),
  -- temp TempDir
  ls.snippet({ trig = [[temp]], desc = [[TempDir]] }, {
    ls.insert_node(1, "TMPDIR"),
    ls.text_node("=\"$(mktemp -d "),
    ls.insert_node(2, ls.function_node(function()
      local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
      if s == "" then return "untitled" end
      return s
    end)),
    ls.text_node({".XXXXXX)\"", "trap \"rm -rf '$"}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"'\" 0               # EXIT", "trap \"rm -rf '$"}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"'; exit 1\" 2       # INT", "trap \"rm -rf '$"}),
    ls.function_node(function(args) return args[1][1] or "" end, {1}),
    ls.text_node({"'; exit 1\" 1 15    # HUP TERM", ""}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }),
  -- plugin dotfiles plugin bootstrap.sh
  ls.snippet({ trig = [[plugin]], desc = [[dotfiles plugin bootstrap.sh]] }, {
    ls.text_node({"source \"$(dirname \"$(dirname \"${BASH_SOURCE[0]}\")\")/util.sh\"", "init_plugin \""}),
    ls.insert_node(1, ls.function_node(function() return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t") end)),
    ls.text_node({"\"", ""}),
    ls.insert_node(2, "env"),
    ls.text_node("_file=\"$(create_plugin_file "),
    ls.insert_node(3, ls.function_node(function(args) return (function(args) return args[1][1] or "" end)({args[1]}) .. ".sh" end, {2})),
    ls.text_node({")\"", ""}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }),

}

