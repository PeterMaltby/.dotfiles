return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        handlers = {
            function(server_name)
                local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
                require('lspconfig')[server_name].setup({
                    capabilities = lsp_capabilities,
                })
            end,
        },
    },

    init = function()
        vim.diagnostic.config({
            virtual_text = true
        })
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, {})
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', '<F9>', vim.lsp.buf.definition, {})
        vim.keymap.set('n', '<F10>', vim.lsp.buf.implementation, {})
        vim.keymap.set('n', '<F11>', vim.lsp.buf.references, {})
        vim.keymap.set('n', '<F12>', vim.lsp.buf.type_definition, {})


        vim.keymap.set({ 'n', 'x' }, '<F3>', function()
            vim.lsp.buf.format({
                async = false,
                timeout_ms = 10000,
            })
        end, opts)
    end,

    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
