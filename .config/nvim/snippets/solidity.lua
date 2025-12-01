local ls = require("luasnip")
local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node

local ext_opts_choice = {
	-- these ext_opts are applied when the node is active (e.g. it has been
	-- jumped into, and not out yet).
	-- this is the table actually passed to `nvim_buf_set_extmark`.
	active = {
		-- highlight the text inside the node red.
		hl_group = "GruvboxRed",
	},
	-- these ext_opts are applied when the node is not active, but
	-- the snippet still is.
	passive = {
		-- add virtual text on the line of the node, behind all text.
		virt_text = { { "choose bro", "Comment" } },
	},
	-- visited or unvisited are applied when a node was/was not jumped into.
	visited = {
		hl_group = "GruvboxBlue",
	},
	unvisited = {
		hl_group = "GruvboxGreen",
	},
	-- and these are applied when both the node and the snippet are inactive.
	snippet_passive = {},
}

local function in_assembly()
	local has_parser, parser = pcall(vim.treesitter.get_parser, 0, "solidity")
	if not has_parser or parser == nil then
		return false
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	-- remove 1 from the row because treesitter start from 0, but lines are indexed from 1.
	local row, col = cursor[1] - 1, cursor[2]

	local langs = parser:parse()
	if langs == nil then
		return false
	end

	local root = langs[1]:root()

	local node = root:descendant_for_range(row, col, row, col)

	-- Walk up the tree to find if we're inside an assembly block
	while node do
		if node:type() == "assembly_statement" then
			return true
		end
		node = node:parent()
	end

	return false
end

return {
	-- Yul
	s({ trig = "assembly", dscr = "assembly block" }, {
		t("assembly {"),
		t({ "", "	" }),
		i(1),
		t({ "", "}" }),
	}),

	s({ trig = "pop", dscr = "pop function for assembly block", show_condition = in_assembly }, {
		t("pop("),
		i(1),
		t({ ")" }),
	}),

	s({ trig = "mload", dscr = "mload function", show_condition = in_assembly }, {
		t("mload("),
		i(1),
		t({ ")" }),
	}),

	s({ trig = "mstore", dscr = "mload function", show_condition = in_assembly }, {
		t("mload("),
		i(1),
		t({ ")" }),
	}),

	-- This should be triggered only if we have a "." before
	s({ trig = "slot", dscr = "variable's slot value", show_condition = in_assembly }, {
		t("slot"),
	}),

	-- Generic

	s({ trig = "f32", dscr = "32 bytes of 1s" }, {
		t("0xffffffffffffffff"),
	}),

	s({ trig = "z32", dscr = "32 bytes of 0s" }, {
		t("0x0000000000000000"),
	}),

	s("kec", {
		t("keccak256("),
		c(1, {
			i(nil, "value"),
			{ t("abi.encode("), i(1, "value"), t(")") },
			{ t("abi.encodePacked("), i(1, "value"), t(")") },
		}, { node_ext_opts = ext_opts_choice }),
		t(");"),
	}),

	s("field", {
		i(1, "type"),
		t(" "),
		i(2, "name"),
		t(";"),
	}),

	s("struct", {
		t("struct "),
		i(1, "Name"),
		t({ " {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
}
