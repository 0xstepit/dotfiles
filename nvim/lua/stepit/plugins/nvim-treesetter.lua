return {
	"nvim-treesitter/nvim-treesitter",
	name = "Treesitter",
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
	},
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"regex",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
			"go",
			"rust",
		},
		highlight = { enable = true },
		autoinstall = true,
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
