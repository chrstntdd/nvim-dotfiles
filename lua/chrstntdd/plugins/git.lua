return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		init = function()
			local base_opts = { silent = true, noremap = true }

			vim.keymap.set(
				"n",
				"<leader>gs",
				"<cmd>Neogit<CR>",
				vim.tbl_extend("force", base_opts, { desc = "Launch neogit" })
			)

			vim.keymap.set(
				"n",
				"<leader>gc",
				"<cmd>Neogit commit<CR>",
				vim.tbl_extend("force", base_opts, { desc = "[G]it [c]ommit" })
			)
			vim.keymap.set(
				"n",
				"<leader>gp",
				"<cmd>Neogit pull<CR>",
				vim.tbl_extend("force", base_opts, { desc = "[G]it [p]ull" })
			)
			vim.keymap.set(
				"n",
				"<leader>gP",
				"<cmd>Neogit push<CR>",
				vim.tbl_extend("force", base_opts, { desc = "[G]it [P]ush" })
			)
			vim.keymap.set(
				"n",
				"<leader>gb",
				"<cmd>Telescope git_branches<CR>",
				vim.tbl_extend("force", base_opts, { desc = "View the [g]it [b]ranches in telescope" })
			)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},
}
