return {
	"nvim-lualine/lualine.nvim",
	opts = {
		sections = {
			lualine_x = {},
			lualine_c = {
				{ "filename", path = 1 }, -- Display full path
			},
		},
	},
}
