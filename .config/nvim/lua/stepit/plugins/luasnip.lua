return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mlaursen/vim-react-snippets",
	},
	opts = function()
		-- local types = require("luasnip.util.types")
		-- return {
		-- 	-- Check if the current snippet was deleted.
		-- 	delete_check_events = "TextChanged",
		-- 	-- Display a cursor-like placeholder in unvisited nodes
		-- 	-- of the snippet.
		-- 	ext_opts = {
		-- 		[types.insertNode] = {
		-- 			unvisited = {
		-- 				virt_text = { { "|", "Conceal" } },
		-- 				virt_text_pos = "inline",
		-- 			},
		-- 		},
		-- 		[types.exitNode] = {
		-- 			unvisited = {
		-- 				virt_text = { { "|", "Conceal" } },
		-- 				virt_text_pos = "inline",
		-- 			},
		-- 		},
		-- 		[types.choiceNode] = {
		-- 			active = {
		-- 				virt_text = { { "(snippet) choice node", "LspInlayHint" } },
		-- 			},
		-- 		},
		-- 	},
		-- }
	end,
	config = function(_, opts)
		local luasnip = require("luasnip")
		luasnip.setup(opts)
		require("luasnip.loaders.from_vscode").lazy_load()
		-- Load custom plugins in snippets folder
		require("luasnip.loaders.from_lua").load({ paths = { "./snippets" } })

		require("vim-react-snippets").lazy_load()

		vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
		vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
		vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
		vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
	end,
}
