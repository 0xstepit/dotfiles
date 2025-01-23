return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  config = function()
    local fidget = require("fidget")

    fidget.setup({
      progress = {
        display = {
          done_style = "Title",
          group_style = "String", -- Highlight group for group name (LSP server name)
          icon_style = "Directory", -- Highlight group for group icons
          done_ttl = 20,
        },
      },
      notification = {
        window = {
          normal_hl = "Comment",
          winblend = 0,
          x_padding = 3, -- Padding from right edge of window boundary
          y_padding = 1, -- Padding from bottom edge of window boundary
        },
      },
    })
  end,
}
