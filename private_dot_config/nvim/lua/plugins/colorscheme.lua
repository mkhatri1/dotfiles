return {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000, -- Ensure it loads first
    init = function ()
        vim.cmd("colorscheme midnight")
    end
}
