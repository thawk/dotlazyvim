local ls = require("luasnip")

return {

  -- melody xxMelody
  ls.snippet([[melody]], {
    ls.text_node("\""),
    ls.insert_node(1, ls.function_node(function() return vim.fn.expand("%:t:r") end)),
    ls.text_node({"Melody\" =", "{", "	\\key "}),
    ls.insert_node(2, ls.function_node(function(args) return "\\\"" .. (function(args) return args[1][1] or "" end)({args[1]}) .. "Key\"" end, {1})),
    ls.text_node(" "),
    ls.insert_node(3, "\\major"),
    ls.text_node({"", "	\\transpose c "}),
    ls.function_node(function(args) return args[1][1] or "" end, {2}),
    ls.text_node({" {", "		\\tempo 4 = "}),
    ls.insert_node(4, "60"),
    ls.text_node({"", "		\\melody", "	}", "}", ""}),
  }, { description = [[xxMelody]] }),

}
