return {
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
  config = function()
    vim.keymap.set("n", "<leader>mp", "<cmd>:MarkdownPreview<CR>")
  end,
}
