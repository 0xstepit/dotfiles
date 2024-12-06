local set = vim.keymap.set

-- General
set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
set("n", "<leader>ee", ":Ex<CR>", { desc = "Toggle Netrw" })
set("n", "<leader>\\", ":nohl<CR>", { desc = "Exit from search" })

-- Windows management
set("n", "<leader><c-v>", "<C-w>v", { desc = "Split window horizontally" })
set("n", "<leader><c-h>", "<C-w>s", { desc = "Split window vertically" })
set("n", "<leader>=", "<C-w>=", { desc = "Set split windows to equal size" })
set("n", "<C-b>", "<c-w>5>") -- bigger
set("n", "<C-c>", "<c-w>5<") -- compact
set("n", "<C-t>", "<C-W>+") -- taller
set("n", "<C-s>", "<C-W>-") -- smaller

-- Movement
set("n", "<C-d>", "<C-d>zz", { desc = "Move half page down with centered cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Move half page up with centered cursor" })
set("n", "[q", ":cn<CR>", { desc = "Move to previous quickfix item" })
set("n", "]q", ":cp<CR>", { desc = "Move to next quickfix item" })
set("c", "<C-j>", "<Down>", { desc = "Move down in command mode" })
set("c", "<C-k>", "<Up>", { desc = "Move up in command mode" })

-- Search
set("n", "n", "nzzzv", { desc = "Search with centered result" })
set("n", "N", "Nzzzv", { desc = "Search backwards with centered result" })
set("n", "<CR>", function()
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
set("n", "J", "mzJ`z", { desc = "Join with next line wihtout changing cursor position" })

-- Copy
set("x", "p", "P", { desc = "Paste without changing clipboard" })

vim.keymap.set("n", "<leader>br", function()
  vim.cmd "bufdo edit!"
  print "All buffers reloaded"
end, { desc = "Reload all buffers" })

-- TODO: change this with boxes
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

local function move_note_command(destination)
  local file_path = vim.fn.fnamemodify(vim.fn.expand "%", ":p")
  local file_name = vim.fn.fnamemodify(vim.fn.expand "%", ":t")
  if vim.fn.fnamemodify(vim.fn.expand "%", ":e") ~= "md" then
    print "Aborting because current file is not a note"
    return { error = true, cmd = "" }
  end

  local notes_dir = os.getenv "NOTES"
  if notes_dir == "" then
    print "Aborting because $NOTES env variable is empty"
    return { error = true, cmd = "" }
  end

  local destination_dir = notes_dir .. "/" .. "main/" .. destination
  local note_path = destination .. "/" .. file_name
  local success = vim.fn.rename(file_path, note_path)
  if success ~= 0 then
    vim.notify "Error while renaming current file name"
    return { error = true, cmd = "" }
  end
  local cmd = ":e " .. note_path
  return { error = false, cmd = cmd }
end

vim.keymap.set("n", "<leader>mr", function()
  local out = move_note_command "2-Resources"
  if out.err ~= true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move the current file to the 2-Resources folder" })

-- TODO: allow selection of multiple files
vim.keymap.set("n", "<leader>mi", function()
  local out = move_note_command "0-Inbox"
  if out.err ~= true then
    vim.cmd(out.cmd)
  end
end, { desc = "Move the current file to the 0-Inbox folder" })

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

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-g>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
