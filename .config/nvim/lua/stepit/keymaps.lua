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
set("n", "<C-d>", "<C-d>zz", { desc = "Move half page down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Move half page up with centered cursor" })

set("n", "[q", ":cn<CR>", { desc = "Move to previous quickfix item" })
set("n", "]q", ":cp<CR>", { desc = "Move to next quickfix item" })

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
set("n", "+", "zc", { desc = "Close fold under cursor" })
set("n", "<leader>-", "zR<CR>", { desc = "Open all folds" })
set("n", "<leader>0", "za", { desc = "Toggle current fold" })

-- vim.api.nvim_set_keymap("n", "<leader>nn", "<cmd>:ObsidianNew<CR>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>br", function()
  vim.cmd "bufdo edit!"
  print "All buffers reloaded"
end, { desc = "Reload all buffers" })

vim.keymap.set("n", "<leader>td", function()
  -- Get the current line
  local current_line = vim.fn.getline "."
  -- Get the current line number
  local line_number = vim.fn.line "."
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
    vim.cmd "echo 'todo item not detected'"
  end
end, { desc = "Toggle item done or not" })

vim.keymap.set("n", "<leader>nn", function()
  local note_title = vim.fn.input "Note title: "
  -- note_title = string.lower(note_title)
  note_title = note_title:gsub("^%l", string.upper)
  local note_title_md = note_title .. ".md"

  local notes_dir = os.getenv "NOTES"
  if notes_dir == "" then
    print "Aborting because $NOTES env variable is empty"
    return
  end

  local inbox_dir = notes_dir .. "/" .. "main/0-Inbox"
  local note_path = inbox_dir .. "/" .. note_title_md

  if vim.fn.filereadable(note_path) == 0 then
    local file = io.open(note_path, "w")
    if file then
      -- Add the frontmatter
      file:write "---\n"
      file:write("author: " .. "Stefano Francesco Pitton\n")
      file:write("title: " .. note_title .. "\n")
      local slug_note_title = note_title:lower():gsub("%s+", "-")
      file:write("slug: " .. slug_note_title .. "\n")
      file:write "tags: []\n"
      file:write "related: []\n"
      local date = os.date "%Y-%m-%d"
      file:write("created: " .. date .. "\n")
      file:write("modified: " .. date .. "\n")
      file:write "to-publish: false\n"
      file:write "---\n\n"
      -- Add header
      file:write("# " .. note_title .. "\n\n")
      file:close()
      local cmd = ":e " .. note_path
      vim.cmd(cmd)
    else
      print("Failed to create file: " .. note_path)
    end
  else
    print("Daily note already exists: " .. note_path)
  end
end, { desc = "[P]H1 heading and date" })
