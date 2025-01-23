return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  opts = {
    indent = {
      char = require("stepit.utils.icons").line.vertical.thin.left,
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = { "Function" },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
