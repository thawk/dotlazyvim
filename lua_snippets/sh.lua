local ls = require("luasnip")

return {

  -- temp Tempfile
  ls.snippet({ trig = [[temp]], desc = [[Tempfile]] }, {
    ls.insert_node(1, "TMPFILE"),
    ls.text_node("=\"$(mktemp -t --suffix="),
    ls.insert_node(2, ".SUFFIX"),
    ls.text_node(" "),
    ls.d(3, function(args, parent)
      local function __dyn_val()
        local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
        if s == "" then return "untitled" end
        return s
      end
      return ls.sn(nil, { ls.i(3, __dyn_val()) })
    end),
    ls.text_node({".XXXXXX)\"", ""}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {4}),
    ls.d(4, function(args, parent)
      local function __dyn_val()
        return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'"
      end
      return ls.sn(nil, { ls.i(4, __dyn_val()) })
    end, {1}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 0               # EXIT\n") end, {4}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {5}),
    ls.d(5, function(args, parent)
      local function __dyn_val()
        return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1"
      end
      return ls.sn(nil, { ls.i(5, __dyn_val()) })
    end, {1}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 2       # INT\n") end, {5}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "trap \"") end, {6}),
    ls.d(6, function(args, parent)
      local function __dyn_val()
        return "rm -f '$" .. (function(args) return (args[1][1] or ""):gsub(".*%s", "") end)({args[1]}) .. "'; exit 1"
      end
      return ls.sn(nil, { ls.i(6, __dyn_val()) })
    end, {1}),
    ls.function_node(function(args) return (args[1][1] or ""):gsub("(.+)", "\" 1 15    # HUP TERM\n") end, {6}),
    ls.text_node({"", "", ""}),
  }),
  -- temp TempDir
  ls.snippet({ trig = [[temp]], desc = [[TempDir]] }, {
    ls.insert_node(1, "TMPDIR"),
    ls.text_node("=\"$(mktemp -d "),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        local s = vim.fn.expand("%:t"):gsub("[^%a]", "_")
        if s == "" then return "untitled" end
        return s
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end),
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
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({"\"", ""}),
    ls.insert_node(2, "env"),
    ls.text_node("_file=\"$(create_plugin_file "),
    ls.d(3, function(args, parent)
      local function __dyn_val()
        return (function(args) return args[1][1] or "" end)({args[1]}) .. ".sh"
      end
      return ls.sn(nil, { ls.i(3, __dyn_val()) })
    end, {2}),
    ls.text_node({")\"", ""}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }),

}

