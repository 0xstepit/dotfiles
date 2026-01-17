local icons = require("stepit.utils.icons")

local languages = {
	"astro",
	"bash",
	"c",
	"css",
	"diff",
	"dockerfile",
	-- GO
	"go",
	"gomod",
	"gowork",
	"gosum",
	"gotmpl",
	"html",
	"javascript",
	"just",
	"json",
	"jsonnet",
	"latex",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"regex",
	"solidity",
	"toml",
	"typescript",
	"rust",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					separator = icons.blocks.upper_one,
					max_lines = 3,
					multiline_threshold = 1,
					min_window_height = 20,
				},
				keys = {
					{
						"[c",
						function()
							require("treesitter-context").go_to_context(vim.v.count1)
						end,
						{ desc = "Jump to upper [C]ontext" },
					},
				},
			},
		},
		opts = {
			indent = { enable = true },
			autoinstall = true,
			ensure_installed = languages,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader><cr>",
					node_incremental = "<leader><cr>",
					scope_incremental = false,
				},
			},
			highlight = { enable = true },
		},
		config = function(_, opts)
			local configs = require("nvim-treesitter.configs").setup(opts)

			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
