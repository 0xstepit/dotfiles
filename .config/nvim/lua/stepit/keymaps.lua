local notes = require("stepit.notes")

local set = vim.keymap.set

set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ================================================================================================
-- Active buffer management
-- ================================================================================================

set("n", "<esc>", ":nohlsearch<cr>", { desc = "Clear search highlights" })

set("n", "<leader><leader>x", function()
	print("Sourcing current file")
	vim.cmd("source %")
end, { desc = "Source current file" })

set("n", "<leader>w", function()
	local status_dict = vim.b.gitsigns_status_dict
	local has_changes = status_dict
		and ((status_dict.added or 0) > 0 or (status_dict.changed or 0) > 0 or (status_dict.removed or 0) > 0)

	local is_modified = vim.bo.modified
	local is_markdown = vim.fs.normalize(vim.fn.expand("%:e")) == "md"

	if is_markdown and has_changes and is_modified then
		notes.update_modified_in_frontmatter(0)
	end

	vim.cmd("w")
	vim.notify("Current file saved", "info")
end, { desc = "Save file" })

set("n", "<leader>yp", function()
	local filePath = vim.fn.expand("%:~")
	vim.fn.setreg("+", filePath)
	print("Yarn current file path")
end, { desc = "[Y]arn file [P]ath to clipboard" })

-- When pasting on a selected line, the selected lines will not
-- replace the pasted text in the clipboard.
set("x", "p", "P", { desc = "Paste without changing clipboard" })

set("v", ">", ">gv", { desc = "Indent in visual mode" })
set("v", "<", "<gv", { desc = "Unindent in visual mode" })

set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

set("n", "U", "<C-r>", { desc = "Redo" })

-- ================================================================================================
-- Movements on active buffer
-- ================================================================================================
--
set("n", "n", "nzzzv", { desc = "Search with centered result" })
set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with centered cursor" })

-- ================================================================================================
-- Windows management
-- ================================================================================================
--
set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

set("n", "<C-t>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
set("n", "<C-s>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
set("n", "<C-c>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
set("n", "<C-b>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

set("n", "<C-w>z", "<C-w>|", { desc = "Maximize window width" })

set("n", "<C-q>", "<cmd>quit<cr>", { desc = "Close current window" })

-- Center mode
set("n", "<leader>z", function()
	require("stepit.utils.center").toggle()
end, { desc = "Toggle centered mode" })

set("n", "<leader>Z", function()
	local width = vim.fn.input("Center width: ", "120")
	width = tonumber(width)
	if width then
		require("stepit.utils.center").set_width(width)
	end
end, { desc = "Set center width" })
