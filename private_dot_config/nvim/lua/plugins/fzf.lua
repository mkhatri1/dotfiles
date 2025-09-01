return {
    "ibhagwan/fzf-lua",
    name = "fzf",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    cmd = { "FzfLua" },
    config = true,
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>",     "Fuzzy find files in cwd" },
        -- { "<leader>fg", "<cmd>FzfLua live_grep<cr>", "Fuzzy find recent files" },
        { "<leader>fj", "<cmd>FzfLua live_grep<cr>", "Fuzzy find recent files" },
        { "<leader>fk", "<cmd>FzfLua buffers<cr>",   "Find string in cwd" },
        { "<leader>fu", "<cmd>FzfLua resume<cr>",    "Re-open last instance" },
        { "<leader>fh", "<cmd>FzfLua help_tags<cr>", "Help with tags" },
    },
    opts = {
        fzf_colors = true,
        winopts = {
            delay = 10, -- Default is 20
        },
        files = {
            rg_opts = [[--color=never --hidden --files -g "!.git"]],
            fd_opts = [[--color=never --hidden --type f --type l --exclude .git]]
        },
        grep = {
            git_icons = true,
            hidden = true,
            follow = true,
            multiprocess = true,
            rg_opts = "--hidden --vimgrep --column --line-number --no-heading --color=never --smart-case --max-columns=4096 --column --no-require-git -e",
            fzf_opts = {
                ['--delimiter'] = "[\\):]",
                ['--with-nth'] = '1,4',
            },
            rg_glob = true
        }
    },
}
