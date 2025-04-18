return {
  "folke/trouble.nvim",
  name = "Trouble",
  enabled = true,
  opts = {
    icons = {
      indent = {
        top = "│ ",
        middle = "├╴",
        last = "└╴",
        fold_open = " ",
        fold_closed = " ",
        ws = "  ",
      },
      folder_closed = "● ",
      folder_open = "o ",
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Project diagnostis",
    },
    {
      "<leader>tT",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer diagnostics",
    },
    {
      "<leader>tl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location list",
    },
    {
      "<leader>tq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix list",
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
  end,
}
