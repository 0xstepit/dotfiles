return {
  "folke/which-key.nvim",
  name = "WhichKey",
  event = "VimEnter",
  opts = {
    delay = 2000,
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "→", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
      mappings = true,
      rules = false, -- disables icons for keymaps
    },
    defaults = {
      mode = { "n", "v" },
      { "<leader>a", group = "H[A]rpoon" },
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>e", group = "N[E]trw" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>n", group = "[N]ote" },
      { "<leader>t", group = "[T]rouble" },
      { "<leader>l", group = "[L]LM" },
    },
    win = {
      border = "rounded",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
  end,
}
