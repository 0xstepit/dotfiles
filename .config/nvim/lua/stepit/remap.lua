-- space as leader
vim.g.mapleader = " "

vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })

vim.keymap.set("n", "<leader>ee", ":Ex<CR>", { desc = "Toggle Netrw" })
vim.keymap.set("n", "<leader>ea", ":Ex %:p:h<CR>", { desc = "Toggle Netrw" })

-- Windows management
vim.keymap.set("n", "<leader><c-v>", "<C-w>v", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader><c-h>", "<C-w>s", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Set split windows to equal size" })

-- using J doesn't move the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with next line wihtout chaingin cursor position" })

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move half page  down with centered cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move half page up with centered cursor" })
vim.keymap.set("n", "<C-K>", "10k<CR>zz", { desc = "Move 10 lines up with centered cursor" })
vim.keymap.set("n", "<C-J>", "10j<CR>zz", { desc = "Move 10 lines down with centered cursor" })

-- search with centered result
vim.keymap.set("n", "n", "nzzzv", { desc = "Search with centered result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })

-- Indentation
vim.keymap.set("v", ">", ">gv", { desc = "Intent multiple lines with hold" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent multiple lines with hold" })

-- move up and down selected text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move multiple lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move multiple lines up" })

vim.keymap.set("x", "p", "P", { desc = "Paste without changing clipboard" })

-- Folding
vim.keymap.set("n", "+", "<cmd>foldclose<CR>", { desc = "Close fold" })
vim.keymap.set("n", "-", "<cmd>foldopen<CR>", { desc = "Open fold" })
vim.keymap.set("n", "<leader>+", "zM<CR>", { desc = "Close all folds" })
-- vim.keymap.set("n", "<leader>", "zR<CR>", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>0", "zczA", { desc = "Open current fold" })

-- Workaround because was not working
vim.keymap.set("n", "<C-I>", "<C-I>", { noremap = true })
