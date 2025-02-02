local M = {}

M.line = {
  vertical = {
    thin = {
      central = "│",
      left = "▏",
    },
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

M.chevron = {
  down = "",
  right = "",
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

M.symbol_kinds = {
  Array = "󰅪",
  Class = "",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰆧",
  Interface = "",
  Keyword = "󰌆",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "󰦨",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
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
