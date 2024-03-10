-- Description: visualize git signs for the current file and allows you to easily
-- use git from nvim.
-- Def: a hunk is a single block of changes.
return {
	"lewis6991/gitsigns.nvim",
	name = "Gitsigns",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "x" },
		},
		-- commit info on the right of a line
		current_line_blame = true,
		current_line_blame_formatter = '<author>, <author_time:%d-%m-%Y> - <summary>',
	},
}
