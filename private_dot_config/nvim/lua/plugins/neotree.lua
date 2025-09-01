return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "3.*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        { "<leader>e", "<CMD>Neotree toggle<CR>", },
        { "<leader>r", "<CMD>Neotree focus<CR>", },
    },
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    cmd = "Neotree",
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
            desc = "Start Neo-tree with directory",
            once = true,
            callback = function()
                if package.loaded["neo-tree"] then
                    return
                else
                    local stats = vim.uv.fs_stat(vim.fn.argv(0))
                    if stats and stats.type == "directory" then
                        require("neo-tree")
                    end
                end
            end,
        })
    end,
    config = function(_, opts)
        vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

        opts.filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                visible = true,
            },
        }

        opts.default_component_configs = {
            indent = {
                with_expanders = true,
                with_markers = true,
            },
            name = {
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                -- Change type
                added     = "✚",
                deleted   = "✖",
                modified  = "",
                renamed   = "󰁕",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            },
        }

        require('neo-tree').setup(opts)

        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*diffview",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end
        })
    end
}
