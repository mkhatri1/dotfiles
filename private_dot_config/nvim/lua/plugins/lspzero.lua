return {
    -- Neovim Lua type definitions (vim.uv, vim.api, etc.)
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Adds luv (libuv) types so vim.uv is recognised
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        'mason-org/mason.nvim',
        build = ":MasonUpdate",
        lazy = false,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    'rafamadriz/friendly-snippets',
                },
                init = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },
        },
        event = 'VimEnter',
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
            },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    update_delay_ms = 50
                }
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            snippets = { preset = 'luasnip' },
        },
        opts_extend = { "sources.default" }
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { "AstroNvim/astrolsp",            opts = {} },
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },
            { 'saghen/blink.cmp' },
            { "b0o/schemastore.nvim",          lazy = false, config = false },
            { "folke/lazydev.nvim" },
        },
        init = function()
            vim.opt.signcolumn = 'yes'
            vim.filetype.add({ extension = { zcustom = 'zsh', vimrc = 'lua' } })
        end,
        opts = {
            servers = {
                bashls = {
                    filetypes = { "sh", "zsh", "bash" }
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            diagnostics = {
                                globals = { 'vim', 'require' },
                            },
                            -- lazydev.nvim injects the workspace library automatically
                            telemetry = {
                                enable = false,
                            },
                        }
                    }
                },
                yamlls = {
                    settings = {
                        yaml = {
                            schemaStore = {
                                enable = false,
                                url = ""
                            },
                            format = {
                                enable = true
                            }
                        }
                    }
                },
                jsonls = {
                    settings = {
                        json = {
                            validate = { enable = true }
                        }
                    }
                }
            }
        },
        config = function(_, opts)
            local default_capabilities = vim.lsp.protocol.make_client_capabilities()

            for server, config in pairs(opts.servers) do
                if server == 'yamlls' then
                    config.settings.yaml.schemas = require("schemastore").yaml.schemas();
                end

                if server == 'jsonls' then
                    config.settings.json.schemas = require("schemastore").json.schemas();
                end

                config.capabilities = vim.tbl_deep_extend(
                    'force',
                    default_capabilities,
                    require('blink.cmp').get_lsp_capabilities(config.capabilities),
                    {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true
                            }
                        }
                    }
                )

                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local kopts = { buffer = event.buf }

                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', kopts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', kopts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', kopts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', kopts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', kopts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', kopts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', kopts)
                    vim.keymap.set({ 'n', 'x' }, 'fo',
                        '<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= "tsgo" end  })<cr>',
                        kopts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', kopts)
                    vim.keymap.set("n", "<Leader>ll",
                        "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<cr>", kopts)
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'biome',
                    'tsgo',
                    'yamlls',
                    'bashls'
                },
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
                    end,
                }
            })
        end
    },

    {
        'linux-cultist/venv-selector.nvim',
        branch = "main",
        dependencies = { 'neovim/nvim-lspconfig' },
        config = function()
            require('venv-selector').setup {}
        end,
        event = 'VeryLazy',
        keys = {
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
        },
    }
}
