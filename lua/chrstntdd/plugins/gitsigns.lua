return {
	"lewis6991/gitsigns.nvim",
	event = { "VeryLazy" },
	config = function()
		local gs = require("gitsigns")
		gs.setup({})
	end,
}
