function dedup(list)
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

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
    init = function (plugin)
        require("lazy.core.loader").add_to_rtp(plugin)
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
        { "<C-Space>", desc = "Increment Selection" },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true,
            disable = {
                'yaml'
            }
        },
        autotag = {
            enable = true,
        },
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "tsx",
            "typescript",
            "vim",
            "yaml",
            "bash",
            "diff",
            "jsdoc",
            "lua",
            "luadoc",
            "luap",
            "regex",
            "toml",
            "vimdoc",
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-Space>",
                node_incremental = "<C-Space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
        rainbow = {
            enable = true,
            disable = { "html" },
            extended_mode = false,
            max_file_lines = nil,
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    },
	config = function(_, opts)
		local treesitter = require("nvim-treesitter.configs")

        if type (opts.ensure_installed) == "table" then
            opts.ensure_installed = dedup(opts.ensure_installed)
        end
		treesitter.setup(opts)
	end,
}

