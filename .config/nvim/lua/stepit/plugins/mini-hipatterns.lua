return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    local hipatterns = require "mini.hipatterns"
    hipatterns.setup {
      highlighters = {
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
        -- ref:https://youtu.be/EJLrssH1ip0?si=cYOc0CZ5Xfwfsy70
        hsl_color = {
          pattern = "hsl%(%d+,? %d+,? %d+%)",
          group = function(_, match)
            local utils = require "tokyonight.hsl"
            local nh, ns, nl = match:match "hsl%((%d+),? (%d+),? (%d+)%)"
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    }
  end,
}
