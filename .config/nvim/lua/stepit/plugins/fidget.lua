return {
  "j-hui/fidget.nvim",
  name = "Fidget",
  event = "VeryLazy",
  config = function()
    local fidget = require "fidget"

    fidget.setup {
      progress = {
        display = {
          done_style = "CursorLineNr",
          done_ttl = 20,
        },
      },
      notification = {
        window = {
          normal_hl = "Comment",
          winblend = 0,
        },
      },
    }
  end,
}
