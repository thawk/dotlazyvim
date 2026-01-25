-- doxygen.lua  ——  一键生成 Doxygen 注释
return {
  ---------------------------------------------------------------------------
  -- 方案 A：dooku.nvim（纯 Lua，异步，支持多种风格）
  ---------------------------------------------------------------------------
  --{
  --  "Zeioth/dooku.nvim",
  --  event = "VeryLazy",
  --  keys = {
  --    { "<leader>cd", "<cmd>DookuGenerate<CR>", desc = "Generate Doxygen" },
  --  },
  --  opts = {
  --        -- 默认就是 doxygen，也可以改成"qt" "jsdoc" ...
  --    style = "doxygen",
  --        -- 生成完自动折叠
  --    fold    = true,
  --        -- 生成完自动格式化（依赖 conform）
  --    format  = true,
  --  },
  --},

  ---------------------------------------------------------------------------
  -- 方案 B：vim-doge（交互式，边写边跳）
  ---------------------------------------------------------------------------
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    event = "VeryLazy",
    keys = {
      { "<leader>cd", "<cmd>DogeGenerate<CR>", desc = "Generate Doxygen" },
    },
    init = function()
      --vim.g.doge_doc_standard = "doxygen_cpp" -- 默认 C++ doxygen
      vim.g.doge_doc_standard_cpp = "doxygen_javadoc" -- 默认 C++ doxygen
      vim.g.doge_mapping = "<leader>cd" -- 与 key 保持一致
      vim.g.doge_doxygen_settings = { char = "@" }
    end,
  },
}
