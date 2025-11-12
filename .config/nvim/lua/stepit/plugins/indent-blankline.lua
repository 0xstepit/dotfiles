return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	enabled = false,
	event = "VeryLazy",
	opts = {
		indent = {
			char = require("stepit.utils.icons").lines.vertical.left,
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			highlight = { "@property" },
		},
	},
	config = function(_, opts)
		require("ibl").setup(opts)
	end,
}
