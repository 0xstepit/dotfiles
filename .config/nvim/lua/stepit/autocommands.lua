vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("stepit/close_with_ctrl_q", { clear = true }),
	desc = "Close with <C-q>",
	pattern = {
		"TelescopePrompt",
		"git",
		"fugitive",
		"help",
		"man",
		"qf",
	},
	callback = function(args)
		vim.keymap.set("n", "<C-q>", "<cmd>quit<cr>", { buffer = args.buf, noremap = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("stepit/minifile_tmux", { clear = true }),
	pattern = "minifile",
	callback = function()
		vim.keymap.set("n", "<c-l>", ":<C-U>TmuxNavigateRight<CR>", { remap = true, buffer = true, silent = true })
		vim.keymap.set("n", "<c-h>", ":<C-U>TmuxNavigateLeft<CR>", { remap = true, buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function()
		local exc = { "TelescopePrompt", "oil", "fugitive", "git", "gitcommit", "qf", "GV" }
		local valid = true
		for _, e in ipairs(exc) do
			if vim.bo.filetype == e then
				valid = false
			end
		end

		if valid then
			vim.wo.cursorline = true
			vim.wo.colorcolumn = "100"
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	callback = function()
		vim.wo.cursorline = false
	end,
})

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function()
-- 		require("fzf-lua").files({
-- 			cwd_only = true,
-- 			include_current_session = true, -- includes files visited during current session.
-- 			cwd_prompt = false,
-- 		})
-- 		-- require("fzf-lua").oldfiles({
-- 		-- 	cwd_only = true,
-- 		-- 	include_current_session = true,
-- 		-- 	previewer = false,
-- 		-- })
-- 	end,
-- })
