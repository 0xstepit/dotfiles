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
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Jump to pane at bottom" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Jump to pane up" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Jump to pane on right" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Jump on previous pane" },
  },
}
