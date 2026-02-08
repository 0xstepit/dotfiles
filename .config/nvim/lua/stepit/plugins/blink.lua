return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	version = "1.*",
	config = function()
		-- Set up custom colors for different completion kinds.
		local kind_colors = {
			Text = "#a6e3a1",
			Method = "#f9e2af",
			Function = "#fab387",
			Constructor = "#f38ba8",
			Field = "#94e2d5",
			Variable = "#cba6f7",
			Class = "#f38ba8",
			Interface = "#eba0ac",
			Module = "#89b4fa",
			Property = "#94e2d5",
			Unit = "#f5c2e7",
			Value = "#f5e0dc",
			Enum = "#f38ba8",
			Keyword = "#cba6f7",
			Snippet = "#a6e3a1",
			Color = "#f5c2e7",
			File = "#89b4fa",
			Reference = "#f2cdcd",
			Folder = "#89b4fa",
			EnumMember = "#eba0ac",
			Constant = "#fab387",
			Struct = "#f38ba8",
			Event = "#f5c2e7",
			Operator = "#89dceb",
			TypeParameter = "#f5e0dc",
		}

		for kind, color in pairs(kind_colors) do
			vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { fg = color })
			vim.api.nvim_set_hl(0, "BlinkCmpKindIcon" .. kind, { fg = color })
		end

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
