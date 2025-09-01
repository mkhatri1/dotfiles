return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    config = function()
        require('bufferline').setup({
            options = {
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "directory",
                        separator = true
                    },
                },
                indicator = {
                    style = "underline"
                },
                hover = {
                    enabled = true,
                }
                -- mode = "tabs"
            }
        })
        vim.opt.termguicolors = true
    end
}
