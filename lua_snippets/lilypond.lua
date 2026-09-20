local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- melody xxMelody
  s({ trig = [[melody]], desc = [[xxMelody]] }, fmt([[
"@1?Melody" =
{
	\key @2? @3?
	\transpose c @2? {
		\tempo 4 = @4?
		\melody
	}
}

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = d(2, function(args, parent) return sn(nil, { i(2, "\\\"" .. (function(args) return args[1][1] or "" end)({args[1]}) .. "Key\"") }) end, {1}),
  [3] = i(3, "\\major"),
  [4] = i(4, "60"),
}, { delimiters = "@?", repeat_duplicates = true })),

}
