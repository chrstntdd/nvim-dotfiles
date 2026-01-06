return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
