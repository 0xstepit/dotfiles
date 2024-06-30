local set = vim.keymap.set

-- General
set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
set("n", "<leader>ee", ":Ex<CR>", { desc = "Toggle Netrw" })

-- Diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Windows management
set("n", "<leader><c-v>", "<C-w>v", { desc = "Split window horizontally" })
set("n", "<leader><c-h>", "<C-w>s", { desc = "Split window vertically" })
set("n", "<leader>=", "<C-w>=", { desc = "Set split windows to equal size" })
set("n", "<C-b>", "<c-w>5>") -- bigger
set("n", "<C-t>", "<C-W>+") -- taller
set("n", "<C-s>", "<C-W>-") -- smaller

-- Movement
set("n", "<C-d>", "<C-d>zz", { desc = "Move half page  down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Move half page up with centered cursor" })

-- Search
set("n", "n", "nzzzv", { desc = "Search with centered result" })
set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return vim.keycode "<CR>"
  end
end, { expr = true, desc = "Exit from search" })

-- Indentation
set("v", ">", ">gv", { desc = "Intent multiple lines with hold" })
set("v", "<", "<gv", { desc = "Unindent multiple lines with hold" })

-- Text movement
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move multiple lines down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move multiple lines up" })
set("n", "J", "mzJ`z", { desc = "Join with next line wihtout chaingin cursor position" })

-- Copy
set("x", "p", "P", { desc = "Paste without changing clipboard" })

-- Folding
set("n", "+", "<cmd>foldclose<CR>", { desc = "Close fold" })
set("n", "-", "<cmd>foldopen<CR>", { desc = "Open fold" })
set("n", "<leader>+", "zM<CR>", { desc = "Close all folds" })
set("n", "<leader>0", "zczA", { desc = "Open current fold" })
