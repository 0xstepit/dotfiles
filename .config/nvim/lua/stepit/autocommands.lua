-- local keybindings = require("stepit.functions.keybindings")
local netrw_augroup = vim.api.nvim_create_augroup("NetrwKeyBindings", { clear = true })
vim.api.nvim_create_autocmd("filetype", {
	group = netrw_augroup,
	pattern = "netrw",
	callback = function()
		vim.keymap.set(
			"n",
			"L",
			"<CR>",
			{ remap = true, buffer = true, desc = "Use to open/close a folder or open a file." }
		)
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<c-l>",
		-- 	":<C-U>TmuxNavigateRight<CR>",
		-- 	{ remap = true, buffer = true, desc = "Use to open/close a folder or open a file." }
		-- )
		vim.keymap.set("n", "<leader><TAB>", "mf", { remap = true, desc = "Use TAB to select file" })
		vim.keymap.set("n", "<leader><S-TAB>", "mF", { remap = true, desc = "Clear selected files" })
		-- vim.keymap.set("n", "cf", "%:w<CR>:buffer #<CR>", { remap = true, desc = "Create and save a new file" })
		vim.keymap.set("n", "fc", "mc", { remap = true, desc = "File copy" })
		vim.keymap.set("n", "fc", "mm", { remap = true, desc = "File move" })
		-- vim.keymap.set("n", "FF", ":NetrwRemoveRecursive<CR>", { remap = true, desc = "Remove a folder recursively" })
	end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd("filetype", {
-- 	-- pattern = { 'netrw', "Trouble", "Harpoon"},
-- 	pattern = { "netrw", "Trouble" },
-- 	desc = "L to open and close folders and open files.",
-- 	callback = function()
-- 		local bind = function(lhs, rhs)
-- 			vim.keymap.set("n", lhs, rhs, { silent = true, remap = true, buffer = true })
-- 		end
-- 		bind("L", "<CR>")
-- 		bind("<c-l>", ":<C-U>TmuxNavigateRight<CR>")
-- 	end,
-- })

-- local function netrw_remove_recursive()
-- 	-- Check if the current file type is 'netrw'
-- 	if vim.bo.filetype == "netrw" then
-- 		-- Map <CR> to 'rm -r<CR>' in command-line mode for the current buffer
-- 		vim.api.nvim_buf_set_keymap(0, "c", "<CR>", "rm -r<CR>", { noremap = true, silent = true })
--
-- 		-- Execute normal mode commands
-- 		vim.api.nvim_command("normal mu")
-- 		vim.api.nvim_command("normal mf")
--
-- 		-- Try to execute 'normal mx' and handle errors
-- 		local status, _ = pcall(vim.api.nvim_command, "normal mx")
-- 		if not status then
-- 			vim.api.nvim_err_writeln("Canceled")
-- 		end
--
-- 		-- Unmap <CR> in command-line mode for the current buffer
-- 		vim.api.nvim_buf_del_keymap(0, "c", "<CR>")
-- 	end
-- end
-- vim.api.nvim_create_user_command("NetrwRemoveRecursive", netrw_remove_recursive, {})
