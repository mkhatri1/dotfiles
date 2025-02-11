return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function ()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
           vim.o.statusline = " "
        else
            vim.o.laststatus = 0
        end
    end,
    config = function()
        require("lualine").setup()
    end,
}

