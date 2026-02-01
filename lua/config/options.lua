-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.env.PYTHON3_HOST_PROG and vim.env.PYTHON3_HOST_PROG ~= "" then
  vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG
end
