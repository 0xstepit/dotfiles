local functions = require("stepit.utils.functions")

local set = vim.keymap.set

-- General
set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
set("n", "E", "ge", { desc = "Go to end of previous word" })
set("n", "<esc>", ":nohlsearch<cr>", { desc = "clear search highlights" })
set("n", "<leader><leader>x", function()
  print("Sourcing project")
  vim.cmd("source %")
end, { desc = "Source all files" })
set("n", "<leader>ts", function()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "[T]oggle [Spell] checking" })

-- Buffer management
set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
set("x", "p", "P", { desc = "Paste without changing clipboard" })
set("x", "p", "P", { desc = "Paste without changing clipboard" })

-- Buffer navigation
set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with centered cursor" })
set("n", "n", "nzzzv", { desc = "Search with centered result" })
set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })

-- Indentation
set("v", ">", ">gv", { desc = "Intent multiple lines" })
set("v", "<", "<gv", { desc = "Unindent multiple lines" })

-- Text movement
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Movement
set("c", "<C-j>", "<Down>", { desc = "Move down in command mode" })
set("c", "<C-k>", "<Up>", { desc = "Move up in command mode" })

-- Windows management
set("n", "<leader><C-v>", "<C-w>v", { desc = "Split window horizontally" })
set("n", "<leader><C-h>", "<C-w>s", { desc = "Split window vertically" })
set("n", "<leader>=", "<C-w>=", { desc = "Set split windows to equal size" })
set("n", "<C-b>", "<c-w>5>", { desc = "Increase split window size on the right" })
set("n", "<C-c>", "<c-w>5<", { desc = "Increase split window size on the left" })
set("n", "<C-t>", "<C-W>+", { desc = "Increase split window size on the top" })
set("n", "<C-s>", "<C-W>-", { desc = "Increase split window size on the bottom" })

----------------------------------------------------------------------------------------
--- Notes management
----------------------------------------------------------------------------------------
local fn = require("stepit.utils.functions")
vim.keymap.set("n", "<leader>mn", function()
  local note_title = vim.fn.input("Note title: ")
  local result = fn.new_note(note_title)
  if result.error then
    vim.notify(result.message, vim.log.levels.ERROR)
  else
    vim.notify(result.message, vim.log.levels.INFO)
  end
end, { desc = "[N]ew note file" })

vim.keymap.set("n", "<leader>mr", function()
  local resources = os.getenv("RESOURCES")
  if not resources or resources == "" then
    return
  end

  local out = functions.move_note_command(resources)
  if not out.err == true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move file to [R]esources" })

vim.keymap.set("n", "<leader>mi", function()
  local inbox = os.getenv("INBOX")
  if not inbox or inbox == "" then
    return
  end
  local out = fn.move_note_command(inbox)
  if out.err ~= true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move file to [I]nbox" })

set("n", "<leader>test", function()
  -- local tab1 = { a = "ciao", b = "anche a te" }
  local tab1 = { "eccomi" }
  local tab2 = { c = "ciao", d = "anche a te" }

  local tabres = vim.tbl_deep_extend("error", tab1, tab2)

  print(vim.inspect(tabres))

  print("KEK")
end, { desc = "[T]oggle [Spell] checking" })
