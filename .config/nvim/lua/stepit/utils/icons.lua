local M = {}

M.species = {
	person = "",
	alien = "󰢚",
}

M.chevrons = {
	down = "",
	right = "",
}

M.lines = {
	vertical = {
		center = "│",
		left = "▏",
	},
	horizontal = {
		bottom = "_",
		center = "⎯",
		top = "‾",
	},
	-- double = "▐",
}

M.medium_lines = {
	center = "┃",
}

M.dashed_lines = {
	center = "┆",
}

M.git = {
	commit = "",
	branch = "",
}

M.status = {
	ok = "✓",
	error = "✗",
}

M.symbols = {
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
	Keyword = "󰌋",
	Method = "󰆧",
	Module = "",
	Operator = "󰆕",
	Property = "󰜢",
	Reference = "󰈇",
	Snippet = "",
	Struct = "",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "󰀫",
	lens = "",
}

M.diagnostic = {
	error = "●",
	warn = "●",
	hint = "●",
	info = "●",
}

return M
