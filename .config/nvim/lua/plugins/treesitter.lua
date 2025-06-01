return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    build = ":TSUpdate",

    opts = {
     ensure_installed = { "rust", "c", "lua", "vim", "vimdoc", "query", "wgsl", "javascript", "typescript" },
     sync_install = false,
     auto_install = true,
 
     highlight = {
         enable = true,
         additional_vim_regex_highlighting = false,
     },
 
 
     incremental_selection = {
         enable = true,
         keymaps = {
             init_selection = "<C-space>",
             node_incremental = "<C-space>",
             scope_incremental = false,
             node_decremental = "<bs>",
         },
     },
    }

}

