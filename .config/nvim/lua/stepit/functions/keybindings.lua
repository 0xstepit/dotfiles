local M = {}

function M.bind(lhs, rhs, opts)
	-- merge two tables using values from the rightmost one
	opts = vim.tbl_extend("force", { silent = false, noremap = false }, opts or {})
	vim.keymap.set("n", lhs, rhs, opts)
end

return M
