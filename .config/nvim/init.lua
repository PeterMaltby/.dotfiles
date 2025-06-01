-- init.lua
-- author: peterm
-- created: 2023-05-12
--  ___  _  _  ___  _____
-- |_ _|| \| ||_ _||_   _|
--  | | | .` | | |   | |
-- |___||_|\_||___|  |_|
--
-------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic vim stuff
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.mouse = ""

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = false

vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 4

vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vimundo/"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.spelllang = "en_gb"
vim.opt.spell = true

Color = Color or "base16-woodland"
vim.cmd.colorscheme(Color)

--templates
local augroupId = vim.api.nvim_create_augroup("templates", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.*",
    command = [[silent! execute ' 0r $HOME/.config/nvim/templates/skeleton.'.expand('<afile>:e')]]
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*",
    command = [[%s#\[:EVAL:]\(.\{-\}\)\[:END:]#\=eval(submatch(1))#ge]]
})
vim.api.nvim_del_augroup_by_id(augroupId)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- vim.keymap.set('n', '<F9>', vim.lsp.buf.definition, {})
-- vim.keymap.set('n', '<F10>', vim.lsp.buf.implementation, {})
-- vim.keymap.set('n', '<F11>', vim.lsp.buf.references, {})
-- vim.keymap.set('n', '<F12>', vim.lsp.buf.type_definition, {})

-- vim.keymap.set({ 'n', 'x' }, '<F3>', function()
--     vim.lsp.buf.format({
--         async = false,
--         timeout_ms = 10000,
--     })
-- end, opts)
-- 
-- vim.diagnostic.config({
--     virtual_text = true
-- })
