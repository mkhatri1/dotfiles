return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    event = "VeryLazy",
    config = function ()
        local blankline = require("ibl")
        local highlight = {
            "CursorColumn",
            "Whitespace",
        }
        blankline.setup({
            -- indent = {
            --     highlight = highlight
            -- },
            scope = { enabled = true }
        })
    end
}
