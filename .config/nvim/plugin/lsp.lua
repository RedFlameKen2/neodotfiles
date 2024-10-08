local lsp = require('lsp-zero')

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.set_sign_icons ({
    error = " ",
    warn = "",
    hint = "",
    info = "",
})

require("mason").setup({
})
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb" }
})
require('mason-lspconfig').setup({
    ensure_installed = {
        "jdtls",
        "clangd",
        "lua_ls",
    },
    handlers = {
        -- function(server_name)
        --     require('lspconfig')[server_name].setup({
        --         capabilities = lsp_capabilities,
        --     })
        -- end,
        clangd = function()
            require('lspconfig').clangd.setup({
                capabilities = lsp_capabilities,
            })
        end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        }
                    }
                }
            })
        end,
    }

})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local ls = require ("luasnip")

require('luasnip.loaders.from_vscode').lazy_load()


cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'cmp_luasnip'},
        {name = 'luasnip', keyword_length = 2},
        {name = 'buffer', keyword_length = 3},
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-l>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end,
    },
})
lsp.setup()
