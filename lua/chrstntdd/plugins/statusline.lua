return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		sections = {
			lualine_x = {},
			lualine_c = {
				{ "filename", path = 1 }, -- Display full path
			},
		},
	},
}
