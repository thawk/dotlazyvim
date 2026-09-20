local ls = require("luasnip")

return {

  -- datey YYYY-MM-DD and weekday for yesterday
  ls.snippet([[datey]], {
    ls.function_node(function() return os.date("%Y-%m-%d %A", os.time() - 24*3600) end),
    ls.text_node({"", ""}),
  }, { wordTrig = true, description = [[YYYY-MM-DD and weekday for yesterday]] }),

}
