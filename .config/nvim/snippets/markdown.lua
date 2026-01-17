local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function in_latex()
	local has_parser, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
	if not has_parser or parser == nil then
		vim.notify("we DON'T have the parser", "log")
		return false
	end

	vim.notify("we have the parser", "log")

	local cursor = vim.api.nvim_win_get_cursor(0)
	-- remove 1 from the row because treesitter start from 0, but lines are indexed from 1.
	local row, col = cursor[1] - 1, cursor[2]

	local langs = parser:parse()
	if langs == nil then
		return false
	end

	local root = langs[1]:root()

	-- Get the node associated with the current position
	local node = root:descendant_for_range(row, col, row, col)

	-- Walk up the tree to find if we're inside an latex block
	while node do
		-- TODO: get the latex block
		if node:type() == "inline" then
			return true
		end
		node = node:parent()
	end

	return false
end

return {
	-- Yul
	s({ trig = "mathcal", dscr = "Insert mathcal style", show_condition = in_latex }, {
		t("\\mathcal{"),
		i(1),
		t({ "}" }),
	}),

	s({ trig = "c", dscr = "Insert inline code" }, {
		t("`"),
		i(1),
		t({ "`" }),
	}),

	s({ trig = "rscode", dscr = "Insert rust block code" }, {
		t("```rust", ""),
		t({ "", "\t" }),
		i(1),
		t({ "", "```" }),
	}),
}
