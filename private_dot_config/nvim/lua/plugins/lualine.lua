return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            vim.o.statusline = " "
        else
            vim.o.laststatus = 0
        end
    end,
    opts = {
        options = {
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    },
}
