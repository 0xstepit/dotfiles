local icons = require("stepit.utils.icons")

return {
  "folke/which-key.nvim",
  name = "WhichKey",
  event = "VimEnter",
  opts = {
    delay = 400,
    icons = {
      breadcrumb = icons.arrow.double, -- symbol used in the command line area that shows your active key combo
      separator = icons.arrow.right, -- symbol used between a key and it's label
      group = icons.sign.single, -- symbol pre-pended to a group
      mappings = true,
      rules = false, -- disables icons for keymaps
    },
    spec = {
      { "<leader>a", group = "H[A]rpoon" },
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>e", group = "N[E]trw" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>m", group = "[M]markdown" },
      { "g", group = "[G]o" },
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
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
