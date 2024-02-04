return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = {
		sections = {
			lualine_x = { "filetype" },
		},
	},
}
