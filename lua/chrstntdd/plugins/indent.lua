return {
	"echasnovski/mini.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
		local plugin = require("mini.indentscope")
		plugin.setup({
			symbol = "│",
			options = { try_as_border = true },
			draw = {
				delay = 0,
				animation = plugin.gen_animation.none(),
			},
		})
	end,
}
