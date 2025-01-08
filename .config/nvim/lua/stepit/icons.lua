local M = {}

M.line = {
  vertical = {
    thin = "▏",
    single = "┃",
    double = "▐",
    dash = "┆",
  },
  horizontal = {
    bottom = "_",
    center = "⎯",
    top = "‾",
  },
}

M.species = {
  person = "",
  alien = "󰢚",
}

M.git = {
  commit = "",
}

M.status = {
  ok = "✓",
  error = "✗",
}

M.arrow = {
  right = "→",
  double = "»",
  fat = "",
}

M.sign = {
  none = "",
  plus = "→",
  double = "»",
  empty = "∅",
}

M.diagnostic = {
  error = "●",
  warn = "●",
  hint = "●",
  info = "●",
}

M.symbols = {
  lens = "",
}

function M.get_borders()
  return {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
  }
end

return M
