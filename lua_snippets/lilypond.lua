local ls = require("luasnip")

return {

  -- melody xxMelody
  ls.snippet({ trig = [[melody]], desc = [[xxMelody]] }, {
    ls.text_node("\""),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
    ls.text_node({"Melody\" =", "{", "	\\key "}),
    ls.d(2, function(args, parent)
      local function __dyn_val()
        return "\\\"" .. (function(args) return args[1][1] or "" end)({args[1]}) .. "Key\""
      end
      return ls.sn(nil, { ls.i(2, __dyn_val()) })
    end, {1}),
    ls.text_node(" "),
    ls.insert_node(3, "\\major"),
    ls.text_node({"", "	\\transpose c "}),
    ls.function_node(function(args) return args[1][1] or "" end, {2}),
    ls.text_node({" {", "		\\tempo 4 = "}),
    ls.insert_node(4, "60"),
    ls.text_node({"", "		\\melody", "	}", "}", ""}),
  }),

}

