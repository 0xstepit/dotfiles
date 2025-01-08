local set = vim.keymap.set
local helpers = require("stepit.helpers.files")

-- General
set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
set("n", "<leader><leader>x", function()
  print("Sourcing project")
  vim.cmd("source %")
end, { desc = "Source" })
set("n", "<leader>x", ":.lua<CR>", { desc = "Source" })

-- Buffer management
set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
set("n", "U", "<C-r>", { desc = "Redo" })
set({ "s", "i", "n", "v" }, "<C-s>", "<esc>:w<cr>", { desc = "Exit insert mode and save changes." })
set("x", "p", "P", { desc = "Paste without changing clipboard" })

-- Window navigation
set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with centered cursor" })
set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change cwd for Telescope" })

-- Search
set("n", "n", "nzzzv", { desc = "Search with centered result" })
set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })

-- Indentation
set("v", ">", ">gv", { desc = "Intent multiple lines" })
set("v", "<", "<gv", { desc = "Unindent multiple lines" })
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Text movement
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move multiple lines down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move multiple lines up" })
set("n", "J", "mzJ`z", { desc = "Join with next line wihtout changing cursor position" })
set("c", "<C-j>", "<Down>", { desc = "Move down in command mode" })
set("c", "<C-k>", "<Up>", { desc = "Move up in command mode" })

-- Windows management
set("n", "<leader><c-v>", "<C-w>v", { desc = "Split window horizontally" })
set("n", "<leader><c-h>", "<C-w>s", { desc = "Split window vertically" })
set("n", "<leader>=", "<C-w>=", { desc = "Set split windows to equal size" })
set("n", "<C-b>", "<c-w>5>", { desc = "Increase split window size on the right" })
set("n", "<C-c>", "<c-w>5<", { desc = "Increase split window size on the left" })
set("n", "<C-t>", "<C-W>+", { desc = "Increase split window size on the top" })
set("n", "<C-s>", "<C-W>-", { desc = "Increase split window size on the bottom" })

local function show_hover_preview()
  print("entered")
  vim.lsp.util.open_floating_preview({ "# HELLOOOOOO" }, "markdown", {
    border = "rounded",
    max_width = 80,
    max_height = 80,
  })
end

vim.keymap.set("n", "H", show_hover_preview, { noremap = true, silent = true })

-- TODO: change this with boxes
vim.keymap.set("n", "<leader>td", function()
  -- Get the current line
  local current_line = vim.fn.getline(".")
  -- Get the current line number
  local line_number = vim.fn.line(".")
  if string.find(current_line, "TODO:") then
    -- Replace the first occurrence of ":" with ";"
    local new_line = current_line:gsub("TODO:", "TODO;")
    -- Set the modified line
    vim.fn.setline(line_number, new_line)
  elseif string.find(current_line, "TODO;") then
    -- Replace the first occurrence of ";" with ":"
    local new_line = current_line:gsub("TODO;", "TODO:")
    -- Set the modified line
    vim.fn.setline(line_number, new_line)
  else
    vim.cmd("echo 'todo item not detected'")
  end
end, { desc = "Toggle item done or not" })

-- Notes handling
vim.keymap.set("n", "<leader>mr", function()
  local out = helpers.move_note_command(helpers.resources)
  if not out.err == true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move file to [R]esources" })

vim.keymap.set("n", "<leader>mi", function()
  local out = helpers.move_note_command(helpers.inbox)
  if out.err ~= true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move file to [I]nbox" })

vim.keymap.set("n", "<leader>mn", function()
  local note_title = vim.fn.input("Note title: ")
  local result = helpers.new_note(note_title)
  if result.error then
    vim.notify(result.message, vim.log.levels.ERROR)
  else
    vim.notify(result.message, vim.log.levels.INFO)
  end
end, { desc = "[N]ew note" })

-- TODO: remove following lines, they are just to play around with the API.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
vim.keymap.set("n", "<space>ot", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)

  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>example", function()
  vim.fn.chansend(job_id, { "ls -al\r\n" })
end, { desc = "Run ls" })
