local M = {}

-- Store state
M.enabled = false
M.left_win = nil
M.right_win = nil
M.left_buf = nil
M.right_buf = nil
M.center_width = 120

-- Create a scratch buffer for padding
local function create_padding_buffer()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].buflisted = false
	return buf
end

-- Configure padding window options
local function configure_padding_window(win)
	local opts = {
		number = false,
		relativenumber = false,
		cursorline = false,
		cursorcolumn = false,
		foldcolumn = "0",
		signcolumn = "no",
		wrap = false,
		list = false,
		spell = false,
	}

	for opt, val in pairs(opts) do
		vim.wo[win][opt] = val
	end

	-- Make it non-focusable via winfixwidth
	vim.wo[win].winfixwidth = true
end

-- Calculate padding width
local function get_padding_width()
	local total_width = vim.o.columns
	local padding = math.floor((total_width - M.center_width) / 2)
	return math.max(padding, 0)
end

-- Enable centered mode
function M.enable()
	if M.enabled then
		return
	end

	local current_win = vim.api.nvim_get_current_win()
	local padding_width = get_padding_width()

	if padding_width <= 0 then
		vim.notify("Window too narrow to center", vim.log.levels.WARN)
		return
	end

	-- Create left padding
	vim.cmd("topleft vsplit")
	M.left_win = vim.api.nvim_get_current_win()
	M.left_buf = create_padding_buffer()
	vim.api.nvim_win_set_buf(M.left_win, M.left_buf)
	vim.api.nvim_win_set_width(M.left_win, padding_width)
	configure_padding_window(M.left_win)

	-- Go back to center window
	vim.api.nvim_set_current_win(current_win)

	-- Create right padding
	vim.cmd("botright vsplit")
	M.right_win = vim.api.nvim_get_current_win()
	M.right_buf = create_padding_buffer()
	vim.api.nvim_win_set_buf(M.right_win, M.right_buf)
	vim.api.nvim_win_set_width(M.right_win, padding_width)
	configure_padding_window(M.right_win)

	-- Return to center window
	vim.api.nvim_set_current_win(current_win)

	M.enabled = true
end

-- Disable centered mode
function M.disable()
	if not M.enabled then
		return
	end

	-- Close padding windows with error handling
	if M.left_win and vim.api.nvim_win_is_valid(M.left_win) then
		pcall(vim.api.nvim_win_close, M.left_win, true)
	end

	if M.right_win and vim.api.nvim_win_is_valid(M.right_win) then
		pcall(vim.api.nvim_win_close, M.right_win, true)
	end

	M.left_win = nil
	M.right_win = nil
	M.left_buf = nil
	M.right_buf = nil
	M.enabled = false
end

-- Toggle centered mode
function M.toggle()
	if M.enabled then
		M.disable()
	else
		M.enable()
	end
end

-- Adjust center width
function M.set_width(width)
	M.center_width = width
	if M.enabled then
		-- Refresh by disabling and re-enabling
		M.disable()
		M.enable()
	end
end

-- Auto-command to handle window resize
local function setup_autocmds()
	local group = vim.api.nvim_create_augroup("CenterMode", { clear = true })

	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			if M.enabled then
				local padding_width = get_padding_width()
				if padding_width > 0 then
					if M.left_win and vim.api.nvim_win_is_valid(M.left_win) then
						vim.api.nvim_win_set_width(M.left_win, padding_width)
					end
					if M.right_win and vim.api.nvim_win_is_valid(M.right_win) then
						vim.api.nvim_win_set_width(M.right_win, padding_width)
					end
				end
			end
		end,
	})
end

setup_autocmds()

return M
