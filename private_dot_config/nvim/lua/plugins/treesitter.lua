local function dedup(list)
    local ret = {}
    local seen = {}
    for _, v in ipairs(list) do
        if not seen[v] then
            table.insert(ret, v)
            seen[v] = true
        end
    end
    return ret
end

-- Languages where treesitter indentation is known to be problematic
local indent_disabled = { "yaml" }

return
{

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            {
                "windwp/nvim-ts-autotag",
                opts = {},
            }
        },
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "gitignore",
                "go",
                "html",
                "http",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "luadoc",
                "luap",
                "markdown_inline",
                "markdown",
                "python",
                "regex",
                "rust",
                "toml",
                "tsx",
                "typescript",
                "typespec",
                "vim",
                "vimdoc",
                "yaml",
            },
            sync_install = false,
            auto_install = true,
        },
        config = function(_, opts)
            local ts = require("nvim-treesitter")

            if vim.fn.executable("git") == 0 then opts.ensure_installed = nil end

            if type(opts.ensure_installed) == "table" then
                opts.ensure_installed = dedup(opts.ensure_installed)
            end

            ts.install(opts.ensure_installed)

            local max_filesize = 200 * 1024 -- 200 KB

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang or lang == "" then return end
                    if not vim.list_contains(ts.get_available(), lang) then return end

                    -- Install parser on demand if not yet installed
                    if not vim.list_contains(ts.get_installed(), lang) then
                        local install_ok = pcall(function() ts.install(lang):wait() end)
                        if not install_ok then return end
                    end

                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 200KB, treesitter disabled for performance",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return
                    end

                    pcall(vim.treesitter.start, args.buf)

                    -- if not vim.list_contains(indent_disabled, lang) then
                    --     vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    -- end
                end
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {
            enable = true,
        }
    }

}
