return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mlaursen/vim-react-snippets",
	},
	opts = function() end,
	config = function(_, opts)
		local luasnip = require("luasnip")

		luasnip.setup(opts)

		require("luasnip.loaders.from_vscode").lazy_load()
		-- Load custom plugins in snippets folder.
		require("luasnip.loaders.from_lua").load({ paths = { "./snippets" } })

		require("vim-react-snippets").lazy_load()

		vim.keymap.set({ "i", "s" }, "<C-n>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
			vim.cmd("redrawstatus")
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-p>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
			vim.cmd("redrawstatus")
		end, { silent = true })
	end,
}
