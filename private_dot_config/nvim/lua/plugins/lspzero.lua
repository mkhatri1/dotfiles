return {
    {
        'mason-org/mason.nvim',
        build = ":MasonUpdate",
        lazy = false,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            -- 'rafamadriz/friendly-snippets',
            {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
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
        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = 'enter',
                -- ['<cr>'] = {
                --     function(cmp) cmp.accept_and_enter() end
                -- }
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    update_delay_ms = 50
                }
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
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
            -- { 'hrsh7th/cmp-nvim-lsp' },
            { "AstroNvim/astrolsp",            opts = {} },
            -- { "ms-jpq/coq_nvim",                  branch = "coq" },
            -- { "ms-jpq/coq.artifacts",             branch = "artifacts" },
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },
            { 'saghen/blink.cmp', },
        },
        init = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

            vim.filetype.add({ extension = { zcustom = 'zsh', vimrc = 'lua' } })
            -- vim.g.coq_settings = {
            --     auto_start = 'shut-up',
            --     keymap = {
            --         recommended = false,
            --         bigger_preview = "<c-o>",
            --         jump_to_mark = null
            --     }
            -- }
        end,
        opts = {
            format_notify = true,
            inlay_hints = { enable = false },
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
                                -- Get the language server to recognize the `vim` global
                                globals = {
                                    'vim',
                                    'require'
                                },
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = {
                                enable = false,
                            },
                        }
                    }
                },
                yamlls = {
                    settings = {
                        yaml = {
                            schemas = {
                                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/**/*.yaml'
                            },
                            schemaStore = {
                                enable = true
                            },
                            format = {
                                enable = true
                            }
                        }
                    }
                }
            }
        },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            local lsp_defaults = lspconfig.util.default_config

            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            -- lsp_defaults.capabilities = vim.tbl_deep_extend(
            --     'force',
            --     lsp_defaults.capabilities,
            --     require('cmp_nvim_lsp').default_capabilities()
            -- )
            --

            lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
                require('blink.cmp').get_lsp_capabilities({}, false))

            lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities, {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true
                    }
                }
            })

            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, 'fo', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                    vim.diagnostic.config({
                        virtual_text = true
                    })
                    vim.keymap.set("n", "<Leader>ll", "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<cr>")
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'biome',
                    'ts_ls'
                },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    bashls = function()
                        require("lspconfig").bashls.setup({
                            filetypes = { "sh", "zsh", "bash" }
                        })
                    end,
                    astrolsp = function(server)
                        require('astrolsp').lsp_setup(server)
                    end,
                }
            })
        end
    },

    {
        'nvimdev/lspsaga.nvim',
        event = 'LspAttach',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
    {
        'linux-cultist/venv-selector.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        branch = "main",
        config = function()
            require('venv-selector').setup {
                -- Your options go here
                -- name = "venv",
                -- auto_refresh = false
            }
        end,
        event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        keys = {
            -- Keymap to open VenvSelector to pick a venv.
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
        },
    }
}
