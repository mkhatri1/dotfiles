return {
    -- maintained fork of norcalli/nvim-colorizer.lua
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
        require("colorizer").setup({ "*" })
    end,
}
