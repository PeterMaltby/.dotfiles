-- init.lua
-- author: peterm
-- created: 2023-05-12
--  ___  _  _  ___  _____ 
-- |_ _|| \| ||_ _||_   _|
--  | | | .` | | |   | |  
-- |___||_|\_||___|  |_|  
--                        
-------------------------------------------------------------
require("plugins")

color = color or "base"
vim.cmd.colorscheme(color)

-- telescope fuzzy finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', function ()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust", "c", "lua", "vim", "vimdoc", "query" },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set({'n', 'x'}, 'gq', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, opts)
end)

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()
lsp.setup()

vim.opt.mouse = ""

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

