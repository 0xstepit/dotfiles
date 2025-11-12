return {
	{
		"0xstepit/flow.nvim",
		enabled = true,
		branch = "main",
		dev = true,
		lazy = false,
		priority = 1000,
		-- tag = "v1.0.0",
		opts = {
			theme = {
				style = os.getenv("COLORSCHEME") or "dark",
				contrast = "default",
				transparent = false,
			},
			colors = {
				mode = "default",
				fluo = "pink",
				custom = {
					-- saturation = "80",
					-- light = "",
				},
			},
			ui = {
				borders = "inverse",
				aggressive_spell = false,
			},
		},
		config = function(_, opts)
			require("flow").setup(opts)
			vim.cmd("colorscheme flow")
		end,
	},
}
