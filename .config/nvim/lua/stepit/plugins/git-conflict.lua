return {
  "akinsho/git-conflict.nvim",
  version = "*",
  opts = {
    default_mappings = {
      ours = "o",
      theirs = "t",
      none = "0",
      both = "b",
      next = "n",
      prev = "p",
    },
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
    list_opener = "ccopen", -- command or function to open the conflicts list
    highlights = { -- They must have background color, otherwise the default color will be used
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
  config = function(_, opts)
    require("git-conflict").setup(opts)
  end,
}
