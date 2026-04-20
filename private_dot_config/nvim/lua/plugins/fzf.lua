return {
    "ibhagwan/fzf-lua",
    name = "fzf",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua" },
    config = true,
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>",     desc = "Fuzzy find files in cwd" },
        { "<leader>fj", "<cmd>FzfLua live_grep<cr>", desc = "Live grep in cwd" },
        { "<leader>fk", "<cmd>FzfLua buffers<cr>",   desc = "Find open buffers" },
        { "<leader>fu", "<cmd>FzfLua resume<cr>",    desc = "Re-open last fzf instance" },
        { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Search help tags" },
    },
    opts = {
        fzf_colors = true,
        winopts = {
            delay = 10,
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
