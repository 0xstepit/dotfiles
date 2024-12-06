return {
  {
    "iamcco/markdown-preview.nvim",
    name = "Markdown Preview",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
    config = function(_, _)
      require("render-markdown").setup {
        heading = {
          enabled = true,
          sign = true,
          position = "overlay",
          icons = {},
          signs = { "󰫎 " },
          width = "full",
          left_margin = 0,
          left_pad = 0,
          right_pad = 0,
          min_width = 0,
          border = false,
          border_virtual = false,
          border_prefix = false,
          above = "▄",
          below = "▀",
        },
      }
    end,
  },
}
