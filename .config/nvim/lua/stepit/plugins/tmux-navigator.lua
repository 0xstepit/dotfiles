-- Description: allows easy movement between panes in vim and tmux,
return {
	"christoomey/vim-tmux-navigator",
	name = "Tmux Navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Jump to pane on left" },
		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Jump on pane down" },
		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Jump on pane up" },
		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Jump on previous pane" },
	},
}
