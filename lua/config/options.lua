-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.env.PYTHON3_HOST_PROG and vim.env.PYTHON3_HOST_PROG ~= "" then
  vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG
end

vim.opt.fileencodings = { "utf-8", "ucs-bom", "gb18030", "gbk", "big5", "latin1" }

-- 将 .base 识别为 obsidian_base
vim.filetype.add({
  extension = {
    base = "obsidian_base",
  },
})

-- 让 obsidian_base 使用 YAML 的 Treesitter parser（Neovim 0.9+）
vim.treesitter.language.register("yaml", "obsidian_base")
