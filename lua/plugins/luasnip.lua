return {
  "L3MON4D3/LuaSnip",
  keys = {
    {
      "<C-l>",
      function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      mode = { "i", "s" },
      desc = "LuaSnip expand or jump",
    },
  },
  opts = function(_, opts)
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./vscode_snippets" } })
    require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua_snippets" } })
  end,
}
