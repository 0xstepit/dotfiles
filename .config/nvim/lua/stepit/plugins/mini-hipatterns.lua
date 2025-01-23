return {
  "echasnovski/mini.hipatterns",
  version = "*",
  event = "BufReadPost",
  opts = function()
    local highlighters = {}
    for _, word in ipairs({ "todo", "note", "hack", "fixme", "debug", "contract" }) do
      highlighters[word] = {
        pattern = string.format(" ()%s():", word:upper()),
        group = string.format("MiniHipatterns%s", word:sub(1, 1):upper() .. word:sub(2)),
      }
    end

    local hipatterns = require("mini.hipatterns")
    highlighters["hex_color"] = hipatterns.gen_highlighter.hex_color()

    return { highlighters = highlighters }
  end,
  config = function(_, opts)
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup(opts)
  end,
}
