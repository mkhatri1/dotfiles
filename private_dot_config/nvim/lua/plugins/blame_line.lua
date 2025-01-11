return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("blame_line").setup()
    end,
}
