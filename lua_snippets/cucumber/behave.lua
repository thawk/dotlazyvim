local ls = require("luasnip")

return {

  -- skel 框架
  ls.snippet([[skel]], {
    ls.text_node({"# language: zh-CN", "功能: "}),
    ls.insert_node(1, ls.function_node(function() return vim.fn.expand("%:t:r") end)),
    ls.text_node({"", "", "	场景: "}),
    ls.insert_node(2),
    ls.text_node({"", "		假如"}),
    ls.insert_node(3),
    ls.text_node({"", "		当"}),
    ls.insert_node(4),
    ls.text_node({"", "		那么"}),
    ls.insert_node(5),
    ls.text_node({"", "	", "	"}),
    ls.insert_node(0),
    ls.text_node({"", ""}),
  }, { description = [[框架]] }),

}
