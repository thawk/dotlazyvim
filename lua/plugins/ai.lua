return {
  "nickjvandyke/opencode.nvim",
  keys = {
    -- Recommended/example keymaps
    {
      "<leader>aa",
      mode = { "n", "x" },
      function()
        require("opencode").ask("@this: ")
      end,
      desc = "Ask OpenCode…",
    },
    {
      "<leader>ap",
      mode = { "n", "x" },
      function()
        require("opencode").select()
      end,
      desc = "Select OpenCode…",
    },
    {
      "<leader>at",
      mode = { "n", "x" },
      function()
        return require("opencode").operator("@this ")
      end,
      desc = "Append range to OpenCode",
      expr = true,
    },
    {
      "<leader>al",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      desc = "Append line to OpenCode",
      expr = true,
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "Scroll OpenCode up",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "Scroll OpenCode down",
    },
  },
}
