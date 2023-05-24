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

-- Basic vim stuff
vim.opt.mouse = ""

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.expandtab = true
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

Color = Color or "base16-woodland"
vim.cmd.colorscheme(Color)

-- plugin manager

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- telescope fuzzy finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<F5>', builtin.find_files, {})
vim.keymap.set('n', '<F6>', builtin.git_files, {})
vim.keymap.set('n', '<F8>', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- undo tree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- treesitter
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust", "c", "lua", "vim", "vimdoc", "query" },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

-- lsp-zero
local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,

    vim.keymap.set('n', '<F9>', vim.lsp.buf.definition, {}),
    vim.keymap.set('n', '<F10>', vim.lsp.buf.implementation, {}),
    vim.keymap.set('n', '<F11>', vim.lsp.buf.references, {}),
    vim.keymap.set('n', '<F12>', vim.lsp.buf.type_definition, {}),
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set({ 'n', 'x' }, '<F3>', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, opts)
end)

lsp.set_sign_icons({
    error = 'X',
    warn = '!',
    hint = '?',
    info = 'i'
})

lsp.nvim_workspace()
lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require('lualine').setup {
    options = {
        icons_enabled = false,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        },
        lualine_x = {
            {
                'diagnostics',
                symbols = { error = 'X:', warn = '!:', info = 'i:', hint = '?:' },
                always_visible = true,
            }
        },
        lualine_y = { 'location' },
        lualine_z = { 'encoding' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
