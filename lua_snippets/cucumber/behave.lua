local ls = require("luasnip")

return {

  -- skel 框架
  ls.snippet({ trig = [[skel]], desc = [[框架]] }, {
    ls.text_node({"# language: zh-CN", "功能: "}),
    ls.d(1, function(args, parent)
      local function __dyn_val()
        return vim.fn.expand("%:t:r")
      end
      return ls.sn(nil, { ls.i(1, __dyn_val()) })
    end),
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
  }),

}

