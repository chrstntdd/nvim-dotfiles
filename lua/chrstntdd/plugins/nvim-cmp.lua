return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
		-- Necessary to bridge luasnip to nvim cmp
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local ls = require("luasnip")
		local fmt = require("luasnip.extras.fmt").fmt

		local snippet = ls.snippet
		local t = ls.text_node
		local c = ls.choice_node
		local i = ls.insert_node
		local sn = ls.snippet_node
		local isn = ls.indent_snippet_node
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			history = true,
			update_events = { "TextChanged", "TextChangedI" },
			snippet = {
				expand = function(args)
					ls.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if ls.expand_or_locally_jumpable() then
						ls.expand_or_jump()
					elseif ls.choice_active() then
						ls.change_choice(1)
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if ls.locally_jumpable(-1) then
						ls.jump(-1)
					elseif ls.choice_active() then
						ls.change_choice(-1)
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "luasnip", max_item_count = 3 },
				{ name = "nvim_lsp" },
				{ name = "buffer", max_item_count = 5 },
				{ name = "path", max_item_count = 4 },
			}),
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			formatting = {
				expandable_indicator = true,
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})

		local ts_tsx = {
			snippet({ trig = "cl", desc = "Print to the console" }, {
				t("console.log("),
				i(1),
				t(")"),
				i(0),
			}),

			snippet({ trig = "lmt", desc = "Lingui msg macro" }, {
				t("_(`"),
				i(1),
				t("`)"),
				i(0),
			}),

			snippet({ trig = "cn", desc = "className attribute as a string literal" }, {
				t('className="'),
				i(1),
				t('"'),
				i(0),
			}),
			snippet({ trig = "cn`", desc = "className attribute as a template string" }, {
				t("className={`${"),
				i(1),
				t("}`}"),
				i(0),
			}),
			snippet({ trig = "cnx", desc = "className attribute with clsx" }, {
				t("className={clsx(["),
				i(1),
				t("])}"),
				i(0),
			}),
			snippet({ trig = "pp", desc = "Pretty print recursively" }, {
				t("console.dir("),
				i(1),
				t(", { depth: Infinity }"),
				t(")"),
				i(0),
			}),
			snippet(
				{ trig = "ReL", desc = "A Remix loader" },
				fmt(
					[[
export async function loader(args: LoaderFunctionArgs) {{
  return {returnType}
}}
      ]],
					{
						returnType = c(1, {
							t("json({ some: {ob: 'ject'} })"),
							t("defer({ some: prom })"),
						}),
					}
				)
			),
		}

		ls.add_snippets("typescript", ts_tsx)
		ls.add_snippets("typescriptreact", ts_tsx)

		vim.keymap.set(
			"n",
			"<leader><leader>s",
			"<cmd>so ~/.config/nvim/lua/chrstntdd/plugins/nvim-cmp.lua<CR><cmd>echo 'reloaded snippets'<CR>"
		)
	end,
}
