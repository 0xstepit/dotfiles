return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	version = "1.*",
	config = function()
		require("blink.cmp").setup({
			keymap = {
				preset = "default",
				["<C-y>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = true },
				menu = {
					auto_show = true,
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description" },
							{ "kind", "source_name", gap = 5 },
						},
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						score_offset = 1000,
					},
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						score_offset = 500,
						max_items = 5,
					},
					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
						score_offset = 300,
						max_items = 5,
					},
					buffer = {
						name = "Buffer",
						module = "blink.cmp.sources.buffer",
						score_offset = 100,
						max_items = 5,
					},
				},
			},
			signature = { enabled = true },
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})
	end,
}
