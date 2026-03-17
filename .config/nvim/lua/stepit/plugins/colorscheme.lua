local theme = os.getenv("COLORSCHEME") or "dark"

local mode = "default"
if theme == "light" then
	mode = "dark"
end

return {
	{
		"0xstepit/flow.nvim",
		enabled = true,
		branch = "stepit/new-scheme",
		dev = true,
		lazy = false,
		priority = 1000,
		-- tag = "v1.0.0",
		opts = {
			theme = {
				style = theme,
				contrast = "default",
				transparent = false,
			},
			colors = {
				mode = mode,
				fluo = "pink",
				-- custom = {
				-- 	saturation = "65",
				-- 	light = "65",
				-- },
			},
			ui = {
				borders = "none",
				aggressive_spell = false,
			},
		},
		config = function(_, opts)
			require("flow").setup(opts)
			vim.cmd("colorscheme flow-mono")
		end,
	},
	{
		"folke/tokyonight.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = {},
		config = function(_, _)
			vim.cmd("colorscheme tokyonight-night")
		end,
	},
}
