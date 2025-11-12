return {
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		init = function()
			vim.g.mkdp_auto_close = 1
		end,
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>mp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
	},
}
