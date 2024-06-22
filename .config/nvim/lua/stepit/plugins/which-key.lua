return {
	"folke/which-key.nvim",
	name = "WhichKey",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "→", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["<leader>a"] = { name = "+harpoon" },
			["<leader>e"] = { name = "+netrw" },
			["<leader>g"] = { name = "+git" },
			["<leader>t"] = { name = "+trouble" },
			["<leader>h"] = { name = "+gitsign" },
			["<leader>f"] = { name = "+telescope" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}
