return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 600,
				silent = true,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>pp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 600,
				silent = true,
			})
		end, { desc = "Format file" })
	end,
}
