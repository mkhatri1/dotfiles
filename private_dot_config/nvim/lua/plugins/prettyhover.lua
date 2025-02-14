return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {},
    config = function ()
        local ph = require("pretty_hover")
        ph.setup({})
    end
}
