return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			heading = {
				enabled = true,
				sign = true,
				position = "overlay",
				icons = {},
				signs = { "" },
			},
			code = {
				sign = false,
				width = "block", -- block
				left_pad = 1,
				-- Minimum width to use for code blocks when width is 'block'
				min_width = 100, -- same length of colorcolumn
				above = "",
				below = "",
			},
			dash = {
				width = 99,
			},
			file_types = { "markdown", "Avante", "copilot-chat", "help" },
			render_modes = { "n", "c" }, -- Only render in normal and command mode, not insert mode
		},
		ft = { "markdown", "Avante" },
		config = function(_, opts)
			require("render-markdown").setup(opts)

			-- Explicitly disable rendering when entering insert mode
			vim.api.nvim_create_autocmd("InsertEnter", {
				pattern = { "*.md", "*.markdown" },
				callback = function()
					vim.cmd("RenderMarkdown disable")
				end,
			})

			-- Re-enable when leaving insert mode
			vim.api.nvim_create_autocmd("InsertLeave", {
				pattern = { "*.md", "*.markdown" },
				callback = function()
					vim.cmd("RenderMarkdown enable")
				end,
			})
		end,
	},
}
