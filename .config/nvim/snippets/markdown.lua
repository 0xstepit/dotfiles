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
	-- Original snippets
	s({ trig = "mathcal", dscr = "Insert mathcal style", show_condition = in_latex }, {
		t("\\mathcal{"),
		i(1),
		t("}"),
	}),

	s({ trig = "c", dscr = "Insert inline code" }, {
		t("`"),
		i(1),
		t("`"),
	}),

	s({ trig = "rscode", dscr = "Insert rust block code" }, {
		t({ "```rust", "" }),
		i(1),
		t({ "", "```" }),
	}),

	-- Math environments
	s({ trig = "mk", dscr = "Inline math" }, {
		t("$"),
		i(1),
		t("$"),
	}),

	s({ trig = "dm", dscr = "Display math" }, {
		t({ "$$", "" }),
		i(1),
		t({ "", "$$" }),
	}),

	s({ trig = "align", dscr = "Align environment" }, {
		t({ "$$", "\\begin{align}", "" }),
		i(1),
		t({ "", "\\end{align}", "$$" }),
	}),

	-- Math symbols and commands
	s({ trig = "mathbb", dscr = "Mathbb style (blackboard bold)" }, {
		t("\\mathbb{"),
		i(1),
		t("}"),
	}),

	s({ trig = "mathbf", dscr = "Bold math" }, {
		t("\\mathbf{"),
		i(1),
		t("}"),
	}),

	s({ trig = "frac", dscr = "Fraction" }, {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
	}),

	s({ trig = "sum", dscr = "Summation" }, {
		t("\\sum_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}),

	s({ trig = "prod", dscr = "Product" }, {
		t("\\prod_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("} "),
		i(0),
	}),

	s({ trig = "int", dscr = "Integral" }, {
		t("\\int_{"),
		i(1, "a"),
		t("}^{"),
		i(2, "b"),
		t("} "),
		i(3),
		t(" \\, d"),
		i(4, "x"),
	}),

	s({ trig = "lim", dscr = "Limit" }, {
		t("\\lim_{"),
		i(1, "x \\to \\infty"),
		t("} "),
		i(0),
	}),

	s({ trig = "sqrt", dscr = "Square root" }, {
		t("\\sqrt{"),
		i(1),
		t("}"),
	}),

	s({ trig = "vec", dscr = "Vector" }, {
		t("\\vec{"),
		i(1),
		t("}"),
	}),

	s({ trig = "mat", dscr = "Matrix" }, {
		t({ "\\begin{bmatrix}", "" }),
		i(1),
		t({ "", "\\end{bmatrix}" }),
	}),

	s({ trig = "cases", dscr = "Cases environment" }, {
		t({ "\\begin{cases}", "" }),
		i(1),
		t({ "", "\\end{cases}" }),
	}),

	-- Greek letters
	s({ trig = "alpha", dscr = "Alpha" }, { t("\\alpha") }),
	s({ trig = "beta", dscr = "Beta" }, { t("\\beta") }),
	s({ trig = "gamma", dscr = "Gamma" }, { t("\\gamma") }),
	s({ trig = "delta", dscr = "Delta" }, { t("\\delta") }),
	s({ trig = "epsilon", dscr = "Epsilon" }, { t("\\epsilon") }),
	s({ trig = "theta", dscr = "Theta" }, { t("\\theta") }),
	s({ trig = "lambda", dscr = "Lambda" }, { t("\\lambda") }),
	s({ trig = "mu", dscr = "Mu" }, { t("\\mu") }),
	s({ trig = "sigma", dscr = "Sigma" }, { t("\\sigma") }),
	s({ trig = "omega", dscr = "Omega" }, { t("\\omega") }),

	-- Additional code blocks
	s({ trig = "code", dscr = "Code block" }, {
		t("```"),
		i(1, "language"),
		t({ "", "" }),
		i(2),
		t({ "", "```" }),
	}),

	s({ trig = "jscode", dscr = "JavaScript code block" }, {
		t({ "```javascript", "" }),
		i(1),
		t({ "", "```" }),
	}),

	s({ trig = "pycode", dscr = "Python code block" }, {
		t({ "```python", "" }),
		i(1),
		t({ "", "```" }),
	}),

	s({ trig = "gocode", dscr = "Go code block" }, {
		t({ "```go", "" }),
		i(1),
		t({ "", "```" }),
	}),

	s({ trig = "shcode", dscr = "Shell code block" }, {
		t({ "```bash", "" }),
		i(1),
		t({ "", "```" }),
	}),

	-- Markdown formatting
	s({ trig = "link", dscr = "Markdown link" }, {
		t("["),
		i(1, "text"),
		t("]("),
		i(2, "url"),
		t(")"),
	}),

	s({ trig = "img", dscr = "Image" }, {
		t("!["),
		i(1, "alt text"),
		t("]("),
		i(2, "url"),
		t(")"),
	}),

	s({ trig = "table", dscr = "Table" }, {
		t({ "| " }),
		i(1, "Header 1"),
		t(" | "),
		i(2, "Header 2"),
		t({ " |", "| --- | --- |", "| " }),
		i(3, "Cell 1"),
		t(" | "),
		i(4, "Cell 2"),
		t(" |"),
	}),

	s({ trig = "todo", dscr = "Todo checkbox" }, {
		t("- [ ] "),
		i(1),
	}),

	s({ trig = "done", dscr = "Done checkbox" }, {
		t("- [x] "),
		i(1),
	}),

	-- Headers
	s({ trig = "h1", dscr = "Header 1" }, {
		t("# "),
		i(1),
	}),

	s({ trig = "h2", dscr = "Header 2" }, {
		t("## "),
		i(1),
	}),

	s({ trig = "h3", dscr = "Header 3" }, {
		t("### "),
		i(1),
	}),

	s({ trig = "h4", dscr = "Header 4" }, {
		t("#### "),
		i(1),
	}),

	-- Frontmatter for notes
	s({ trig = "front", dscr = "Note frontmatter" }, {
		t({ "---", "" }),
		t("author: "),
		i(1, "stepit"),
		t({ "", "" }),
		t("title: '"),
		i(2, "Title"),
		t({ "'", "" }),
		t("slug: '"),
		i(3, "slug"),
		t({ "'", "" }),
		t("created: "),
		i(4, os.date("%Y-%m-%d")),
		t({ "", "" }),
		t("modified: "),
		i(5, os.date("%Y-%m-%d")),
		t({ "", "" }),
		t("summary: '"),
		i(6),
		t({ "'", "" }),
		t("category: '"),
		i(7),
		t({ "'", "" }),
		t("tags: ["),
		i(8),
		t({ "]", "" }),
		t({ "related: []", "" }),
		t("to-publish: "),
		i(9, "false"),
		t({ "", "---", "", "" }),
		i(0),
	}),

	-- Emphasis
	s({ trig = "b", dscr = "Bold" }, {
		t("**"),
		i(1),
		t("**"),
	}),

	s({ trig = "i", dscr = "Italic" }, {
		t("*"),
		i(1),
		t("*"),
	}),

	s({ trig = "bi", dscr = "Bold italic" }, {
		t("***"),
		i(1),
		t("***"),
	}),

	s({ trig = "quote", dscr = "Blockquote" }, {
		t("> "),
		i(1),
	}),

	s({ trig = "hr", dscr = "Horizontal rule" }, {
		t("---"),
	}),

	-- Definition block
	s({ trig = "def", dscr = "Definition block" }, {
		t({ '<div class="definition">', '  <div class="definition-header">' }),
		t({ "", '    <strong class="definition-type">[Def]</strong>' }),
		t({ "", '    <strong class="definition-title">' }),
		i(1, "Title"),
		t({ "</strong>", "  </div>", "  " }),
		i(2, "Definition content"),
		t({ "", "</div>" }),
	}),
}
