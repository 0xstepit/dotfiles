-- space as leader
vim.g.mapleader = ' '

-- exit from insert mode
vim.keymap.set("i", 'jj', "<Esc>")

-- remove search highlight
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>")

-- save file
vim.keymap.set("n", '<leader>w', ":w<CR>")

-- using J doesn't move the cursor
vim.keymap.set("n", 'J', "mzJ`z")

-- half page movement with centered cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- move up and down multiple lines maintaining the cursor in
-- the center of the screen
vim.keymap.set("n", "<C-K>", "10k<CR>zz")
vim.keymap.set("n", "<C-J>", "10j<CR>zz")

-- search with centered result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- allows to indent multiple times in visual mode
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- move up and down selected text in visual mode
vim.keymap.set("v", 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set("v", 'K', ":m '<-2<CR>gv=gv")

-- use register 0 when pasting in visual mode
vim.keymap.set("x", "p", '"0p')

-- folding
vim.keymap.set("n", "+", "<cmd>foldclose<CR>")
vim.keymap.set("n", "-", "<cmd>foldopen<CR>")
vim.keymap.set("n", "<leader>+", "zM<CR>")
vim.keymap.set("n", "<leader>", "zR<CR>")

-- jump pane on left
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>")
-- jump pane on bottom
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
-- jump pane on top
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
-- jump pane on right
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")

-- open split horizontal
vim.keymap.set("n", "<leader><c-v>", ":vs<CR>")

-- toggle netrw
vim.keymap.set("n", '<leader>ee', ":Ex<CR>")

-- bind L to select for opening and closing folders
vim.api.nvim_create_autocmd('filetype', {
	pattern = { 'netrw', "Trouble" },
	desc = 'L to open and close folders and open files.',
	callback = function()
		local bind = function(lhs, rhs)
			vim.keymap.set('n', lhs, rhs, { silent=true, remap = true, buffer = true })
		end
		bind('L', '<CR>')
		bind('<c-l>', ':<C-U>TmuxNavigateRight<CR>' )
	end
})
