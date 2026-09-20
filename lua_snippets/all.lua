local ls = require("luasnip")

return {

  -- datey YYYY-MM-DD and weekday for yesterday
  ls.snippet({ trig = [[datey]], desc = [[YYYY-MM-DD and weekday for yesterday]] }, {
    ls.function_node(function() return os.date("%Y-%m-%d %A", os.time() - 24*3600) end),
    ls.text_node({"", ""}),
  }),

}

