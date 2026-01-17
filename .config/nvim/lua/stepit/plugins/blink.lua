return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },

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
					max_items = 5,
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
	},
	opts_extend = { "sources.default" },
}
-- return {
-- 	"saghen/blink.cmp",
-- 	event = "InsertEnter",
-- 	dependencies = {
-- 		"rafamadriz/friendly-snippets",
-- 		{ "L3MON4D3/LuaSnip", version = "v2.*" },
-- 	},
-- 	version = "1.*",
-- 	opts = {
-- 		-- All presets have the following mappings:
-- 		-- C-space: Open menu or open docs if already open
-- 		-- C-n/C-p or Up/Down: Select next/previous item
-- 		-- C-e: Hide menu
-- 		-- C-k: Toggle signature help (if signature.enabled = true)
-- 		--
-- 		-- See :h blink-cmp-config-keymap for defining your own keymap
-- 		keymap = {
-- 			preset = "default",
-- 			["<Tab>"] = {
-- 				function(cmp)
-- 					if cmp.snippet_active() then
-- 						return cmp.accept()
-- 					else
-- 						return cmp.select_next()
-- 					end
-- 				end,
-- 				"snippet_forward",
-- 				"fallback",
-- 			},
-- 			["<S-Tab>"] = {
-- 				function(cmp)
-- 					if cmp.snippet_active() then
-- 						return cmp.accept()
-- 					else
-- 						return cmp.select_prev()
-- 					end
-- 				end,
-- 				"snippet_backward",
-- 				"fallback",
-- 			},
-- 			["<C-q>"] = { "hide", "fallback" },
-- 			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
-- 			["<C-b>"] = { "scroll_documentation_up", "fallback" },
-- 			["<C-f>"] = { "scroll_documentation_down", "fallback" },
-- 			["<C-c>"] = { "show" },
-- 			["<CR>"] = {
-- 				function(cmp)
-- 					if cmp.snippet_active then
-- 						return cmp.accept()
-- 					end
-- 				end,
-- 				"fallback",
-- 			},
-- 			["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
-- 		},
-- 		appearance = {
-- 			nerd_font_variant = "mono",
-- 		},
-- 		completion = {
-- 			documentation = { auto_show = true },
-- 			accept = { auto_brackets = { enabled = false } },
-- 			list = {
-- 				selection = { preselect = false, auto_insert = true },
-- 				cycle = { from_bottom = true, from_top = true },
-- 			},
-- 			menu = {
-- 				auto_show = true,
-- 				draw = {
-- 					columns = {
-- 						{ "kind_icon" },
-- 						{ "label", "label_description" },
-- 						{ "kind", "source_name" },
-- 					},
-- 				},
-- 			},
-- 		},
-- 		signature = { enabled = true },
-- 		snippets = { preset = "luasnip" },
-- 		-- Default list of enabled providers defined so that you can extend it
-- 		-- elsewhere in your config, without redefining it, due to `opts_extend`
-- 		sources = {
-- 			default = { "lsp", "path", "snippets", "buffer" },
-- 			providers = {
-- 				lsp = {
-- 					name = "LSP",
-- 					module = "blink.cmp.sources.lsp",
-- 					enabled = true, -- Explicitly enable
-- 					score_offset = 1000, -- Higher score = higher priority
-- 					max_items = 5,
-- 				},
-- 				snippets = {
-- 					name = "Snippets",
-- 					module = "blink.cmp.sources.snippets",
-- 					score_offset = 500,
-- 					max_items = 5,
-- 				},
-- 				path = {
-- 					name = "Path",
-- 					module = "blink.cmp.sources.path",
-- 					score_offset = 300,
-- 					max_items = 5,
-- 				},
-- 				buffer = {
-- 					name = "Buffer",
-- 					module = "blink.cmp.sources.buffer",
-- 					score_offset = 100,
-- 					max_items = 5,
-- 				},
-- 			},
-- 		},
-- 	},
--
-- 	opts_extend = { "sources.default" },
-- }
