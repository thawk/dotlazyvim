local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- datey YYYY-MM-DD and weekday for yesterday
  s({ trig = [[datey]], desc = [[YYYY-MM-DD and weekday for yesterday]] }, fmt([[
@x1?

]], {
  x1 = f(function() return os.date("%Y-%m-%d %A", os.time() - 24*3600) end),
}, { delimiters = "@?", repeat_duplicates = true })),

}
