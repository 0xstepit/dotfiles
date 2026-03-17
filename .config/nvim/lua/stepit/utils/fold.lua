-- Custom multi-line fold display using virtual text
-- Shows folds in VSCode style across 3 lines:
--   function foo() {
--     ...10 lines...
--   }

local M = {}

-- Namespace for our fold extmarks
local ns = vim.api.nvim_create_namespace("stepit_fold_display")

-- Cache to track which folds we've already decorated
local decorated_folds = {}

---Clear all fold decorations in a buffer
---@param bufnr number
local function clear_decorations(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	decorated_folds[bufnr] = {}
end

---Get fold info for a line
---@param bufnr number
---@param lnum number line number (1-indexed)
---@return number|nil foldstart, number|nil foldend
local function get_fold_at_line(bufnr, lnum)
	-- Check if this line is the start of a closed fold
	local foldclosed = vim.fn.foldclosed(lnum)
	if foldclosed == -1 then
		return nil, nil
	end

	local foldend = vim.fn.foldclosedend(lnum)
	return foldclosed, foldend
end

---Update fold decorations for visible range in buffer
---@param bufnr number
local function update_fold_decorations(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	-- Clear previous decorations
	clear_decorations(bufnr)

	-- Get visible line range in current window
	local winid = vim.fn.bufwinid(bufnr)
	if winid == -1 then
		return
	end

	local first_line = vim.fn.line("w0", winid)
	local last_line = vim.fn.line("w$", winid)

	-- Track which fold starts we've already processed
	local processed = {}

	for lnum = first_line, last_line do
		local foldstart, foldend = get_fold_at_line(bufnr, lnum)

		if foldstart and not processed[foldstart] then
			processed[foldstart] = true

			-- Get the last line content
			local last_line_content = vim.fn.getline(foldend)
			local line_count = foldend - foldstart + 1

			-- Remove leading whitespace from last line
			local leading_spaces = last_line_content:match("^%s*") or ""
			local trimmed_last = last_line_content:gsub("^%s*", "")

			-- Create virtual lines
			local virt_lines = {
				-- Line with fold count (indented to match code)
				{ { leading_spaces .. "  ..." .. line_count .. " lines...", "Comment" } },
				-- Line with closing brace/statement
				{ { last_line_content, "Normal" } },
			}

			-- Add virtual lines below the fold start (0-indexed for API)
			vim.api.nvim_buf_set_extmark(bufnr, ns, foldstart - 1, 0, {
				virt_lines = virt_lines,
				virt_lines_above = false,
			})

			-- Track this decoration
			if not decorated_folds[bufnr] then
				decorated_folds[bufnr] = {}
			end
			decorated_folds[bufnr][foldstart] = true
		end
	end
end

---Set up autocmds for fold decoration
function M.setup()
	-- Clear the foldtext since we're using virtual lines instead
	vim.o.foldtext = ""

	-- Create autocommands
	local group = vim.api.nvim_create_augroup("StepitFoldDisplay", { clear = true })

	-- Update decorations when cursor moves or window scrolls
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		callback = function()
			update_fold_decorations(vim.api.nvim_get_current_buf())
		end,
	})

	-- Update when entering a buffer or window
	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinScrolled" }, {
		group = group,
		callback = function()
			update_fold_decorations(vim.api.nvim_get_current_buf())
		end,
	})

	-- Clear decorations when buffer is unloaded
	vim.api.nvim_create_autocmd("BufUnload", {
		group = group,
		callback = function(args)
			decorated_folds[args.buf] = nil
		end,
	})

	-- Initial decoration for current buffer
	vim.defer_fn(function()
		update_fold_decorations(vim.api.nvim_get_current_buf())
	end, 100)
end

return M
