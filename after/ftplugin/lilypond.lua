-- ~/.config/nvim/after/ftplugin/python.lua
vim.opt_local.makeprg = "python3 -m py_compile %"
vim.opt_local.errorformat = "%E%f:%l:%c: %m,%f:%l: %m"
vim.opt_local.errorformat:append("%f:%l:%c: %m,%f:%l: %m,In file included from %f:%l:,^I^Ifrom %f:%l%m")
vim.opt_local.errorformat:append("%DChanging working directory to: `%f'")
vim.opt_local.errorformat:append("%XConverting to")
