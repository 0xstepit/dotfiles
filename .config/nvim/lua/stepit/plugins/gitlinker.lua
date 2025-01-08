return {
  "ruifm/gitlinker.nvim",
  name = "Gitlinker",
  lazy=true,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local gitlinker = require "gitlinker"

    gitlinker.setup {}

    vim.keymap.set("n", "<leader>gy", function()
      gitlinker.get_buf_range_url()
    end, { desc = "Get repository link" })
  end,
}
