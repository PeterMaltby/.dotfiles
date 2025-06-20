return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",  -- source for text in buffer
        "hrsh7th/cmp-path",    -- source for file system paths
        "hrsh7th/cmp-cmdline", -- source for file system paths
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
        },
        -- "rafamadriz/friendly-snippets",
        -- "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = require('cmp').config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = "buffer" },
                { name = "path" },
            }),
            mapping = {
                -- ... Your other mappings ...
                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                                behavior = cmp.ConfirmBehavior.Replace,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<C-Space>"] = cmp.mapping.complete(),

                ["<C-e>"] = cmp.mapping.close(),

                -- ["<esc>"] = cmp.mapping(function(fallback)
                --     if cmp.visible() then
                --         cmp.abort()
                --     else
                --         fallback()
                --     end
                -- end, { "i", "c" }),


                -- ... Your other mappings ...
            },
        })
    end,
}
