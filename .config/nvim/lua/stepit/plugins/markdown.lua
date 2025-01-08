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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = {},
        signs = { "" },
      },
      code = {
        sign = false,
        width = "block", -- block
        left_pad = 1,
        -- Minimum width to use for code blocks when width is 'block'
        min_width = 100, -- same length of colorcolumn
        above = "",
        below = "",
      },
      dash = {
        width = 99,
      },
      file_types = { "markdown", "Avante", "copilot-chat", "help" },
      render_modes = true,
    },
    ft = { "markdown", "Avante" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
