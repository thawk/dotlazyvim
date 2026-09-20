return {
  {
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
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local orig_format = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if orig_format then
          item = orig_format(entry, item)
        end
        local data = entry.completion_item and entry.completion_item.data
        local snip = data and require("luasnip").get_id_snippet(data.snip_id)
        if snip and snip.dscr and #snip.dscr > 0 then
          local desc = type(snip.dscr) == "table" and table.concat(snip.dscr, " ") or snip.dscr
          if desc and desc ~= "" then
            item.menu = desc
          end
        end
        return item
      end
    end,
  },
}
