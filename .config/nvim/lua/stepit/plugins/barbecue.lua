return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  opts = {
    exclude_filetypes = { "netrw", "oil", "gitcommit" },
  },
  config = function()
    require("barbecue").setup({
      theme = {
        basename = { fg = "#1ffff5" },
      },
    })
  end,
}
