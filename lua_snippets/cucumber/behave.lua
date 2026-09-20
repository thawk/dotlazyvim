local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {

  -- skel 框架
  s({ trig = [[skel]], desc = [[框架]] }, fmt([[
# language: zh-CN
功能: @1?

	场景: @2?
		假如@3?
		当@4?
		那么@5?
	
	@0?

]], {
  [1] = d(1, function(args, parent) return sn(nil, { i(1, vim.fn.expand("%:t:r")) }) end),
  [2] = i(2),
  [3] = i(3),
  [4] = i(4),
  [5] = i(5),
  [0] = i(0),
}, { delimiters = "@?", repeat_duplicates = true })),

}
