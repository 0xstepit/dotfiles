return {
  "utilyre/barbecue.nvim",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  opts = {
    exclude_filetypes = { "netrw", "oil", "gitcommit" },
    theme = "auto",
  },
  config = function(_, opts)
    require("barbecue").setup({opts})
  end,
}
