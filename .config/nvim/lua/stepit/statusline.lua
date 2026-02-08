local icons = require("stepit.utils.icons")

local M = {}

-- Helper to check if current window is active
local function is_active()
	return vim.g.statusline_winid == vim.api.nvim_get_current_win()
end

-- Helper to get highlight group based on active state
local function hl(active_group, inactive_group)
	return is_active() and ("%#" .. active_group .. "#") or ("%#" .. (inactive_group or "StatusLineNC") .. "#")
end

M.hl_statusline = function() return hl("Statusline", "StatusLineNC") end
M.hl_mode = function() return hl("StatuslineMode", "StatusLineNC") end
M.hl_git_branch = function() return hl("StatuslineGitBranch", "StatusLineNC") end
M.hl_filetype = function() return hl("StatuslineGitBranch", "StatusLineNC") end
M.hl_snippet = function()
	return hl("DiagnosticWarn", "StatusLineNC")
end
M.hl_diagnostic = {
	ERROR = function() return hl("DiagnosticError", "StatusLineNC") end,
	WARN = function() return hl("DiagnosticWarn", "StatusLineNC") end,
	INFO = function() return hl("DiagnosticInfo", "StatusLineNC") end,
	HINT = function() return hl("DiagnosticHint", "StatusLineNC") end,
}

---@return string
function M.mode()
	local mode_to_char = {
		["n"] = "N",
		["no"] = "N",
		["v"] = "V",
		["V"] = "VL",
		[""] = "VB",
		["s"] = "S",
		["S"] = "SL",
		[""] = "SB",
		["i"] = "I",
		["ic"] = "I",
		["R"] = "R",
		["Rv"] = "VR",
		["c"] = "C",
		["cv"] = "EX",
		["ce"] = "EX",
		["r"] = "P",
		["rm"] = "M",
		["r?"] = "C",
		["!"] = "SH",
		["t"] = "T",
	}
	local mode = mode_to_char[vim.api.nvim_get_mode().mode] or "?"

	return string.format("%s %s %s", M.hl_mode(), string.upper(mode), M.hl_statusline())
end

function M.line_info()
	if vim.bo.filetype == "alpha" then
		return ""
	end

	return " %P L%03l:C%02c "
end

---@return string
function M.file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))

	if size <= 0 then
		return ""
	elseif size >= 1024 * 1024 then
		return string.format(" %.2fMB ", size / (1024 * 1024))
	elseif size >= 1024 then
		return string.format(" %.2fKB ", size / 1024)
	else
		return string.format(" %.2f ", size)
	end
end

---@return string
function M.git_info()
	local branch_icon = require("stepit.utils.icons").git.branch

	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end

	return string.format("%s %s %s %s", M.hl_git_branch(), branch_icon, git_info.head, M.hl_statusline())
end

---@return string
function M.file_type()
	-- Equivalent to " %Y "
	return string.format("%s %s %s", M.hl_filetype(), vim.bo.filetype:upper(), M.hl_statusline())
end

---@return string
function M.diagnostic()
	local counts = vim.iter(vim.diagnostic.get(0)):fold({
		ERROR = 0,
		WARN = 0,
		INFO = 0,
		HINT = 0,
	}, function(acc, diagnostic)
		local severity = vim.diagnostic.severity[diagnostic.severity]
		acc[severity] = acc[severity] + 1
		return acc
	end)

	local diagnostics = vim.iter(counts)
		:map(function(severity, count)
			if count == 0 then
				return nil -- skip
			end

			-- return string.format("%s %s:%s %s", M.hl_diagnostic[severity](), severity:sub(1, 1), count, M.hl_statusline())
			return string.format(
				"%s %s %s %s",
				M.hl_diagnostic[severity](),
				icons.diagnostic[severity:lower()],
				count,
				M.hl_statusline()
			)
		end)
		:totable()

	return table.concat(diagnostics, "")
end

---@return string
function M.active_lsp_client()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if not clients then
		return ""
	end

	local clients_ = {}
	for _, client in pairs(clients) do
		table.insert(clients_, client.name)
	end

	if next(clients_) == nil then
		return ""
	end

	return string.format("%s %s %s", M.hl_mode(), table.concat(clients_, ", "), M.hl_statusline())
end

--- Returns the statusline information for snippets.
---@return string A non empty string if there is a jumpable position.
function M.snippet_status()
	local ok, luasnip = pcall(require, "luasnip")
	if not ok then
		return ""
	end

	-- Show indicator if there's a snippet position to jump to.
	-- This is useful when in insert mode and you press TAB. If a previous snippet is still active,
	-- the cursor will jump to that snippet position.
	if luasnip.jumpable(1) or luasnip.jumpable(-1) then
		return string.format("%s SNIP %s", M.hl_snippet(), M.hl_statusline())
	end

	return ""
end

---@return string
function M.render()
	return M.mode()
		.. M.git_info()
		.. M.snippet_status()
		-- .. "%="
		.. M.diagnostic()
		.. "%="
		.. " %m " -- modified
		.. M.line_info()
		.. M.file_size()
		.. M.file_type()
		.. M.active_lsp_client()
end

vim.o.statusline = "%!v:lua.require'stepit.statusline'.render()"

return M
