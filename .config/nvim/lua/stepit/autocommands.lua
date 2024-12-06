local function is_file_modified(buffer)
  return vim.bo[buffer].modified
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("MdBlog", { clear = true }),
  pattern = "markdown",
  callback = function()
    local function extract_modified_date(line)
      local date = line:match "modified:%s+(%d%d%d%d%-%d%d%-%d%d)"
      return date
    end

    local function update_modified_date()
      local line_nr = 1
      local found = false
      local old_date = ""
      local current_date = os.date "%Y-%m-%d"

      local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
      if line:find "%-%-%-" ~= nil then
        while true do
          line = vim.api.nvim_buf_get_lines(0, line_nr, line_nr + 1, false)[1]
          if not line or line:find "%-%-%-" ~= nil then
            break
          end

          local modified_date = extract_modified_date(line)
          if modified_date then
            if modified_date <= current_date then
              found = true
              old_date = modified_date
              break
            end
          end

          line_nr = line_nr + 1
        end
      end
      if found then
        -- local updated_line = string.gsub(line, old_date, current_date)
        -- vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, { updated_line })
        local new_line = "modified: " .. current_date
        vim.api.nvim_buf_set_lines(0, line_nr, line_nr + 1, false, {})
        vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, { new_line })
      end
    end

    vim.keymap.set("n", "<leader>w", function()
      if is_file_modified(0) then
        update_modified_date()
        vim.notify "Last modified date has been updated!"
      end
      -- vim.cmd "write"
      local ok, err = pcall(function()
        vim.cmd "write"
      end)
      if ok then
        vim.notify(err)
      end
    end, { desc = "Update modified date in mardown files" })
  end,
})

-- local keybindings = require("stepit.functions.keybindings")
vim.api.nvim_create_augroup("NetrwKeyBindings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "NetrwKeyBindings",
  pattern = "netrw",
  callback = function()
    vim.keymap.set(
      "n",
      "L",
      "<CR>",
      { remap = true, buffer = true, desc = "Use to open/close a folder or open a file." }
    )
    vim.keymap.set("n", "<leader><TAB>", "mf", { remap = true, desc = "Select file" })
    vim.keymap.set("n", "<leader><S-TAB>", "mF", { remap = true, desc = "Clear selected files" })
    vim.keymap.set("n", "fc", "mc", { remap = true, desc = "File copy" })
    vim.keymap.set("n", "fc", "mm", { remap = true, desc = "File move" })

    vim.keymap.set(
      "n",
      "<c-l>",
      ":<C-U>TmuxNavigateRight<CR>",
      { remap = true, buffer = true, desc = "Use to open/close a folder or open a file." }
    )
    -- vim.keymap.set("n", "cf", "%:w<CR>:buffer #<CR>", { remap = true, desc = "Create and save a new file" })
    -- vim.keymap.set("n", "FF", ":NetrwRemoveRecursive<CR>", { remap = true, desc = "Remove a folder recursively" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "netrw" then
      vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove cursorline from inactive windows.
vim.api.nvim_create_augroup("CursorLine", { clear = true })

-- TODO: fix on telescope to disable cursorline
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = "CursorLine",
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" then
      vim.opt.cursorline = true
    else
      vim.opt.cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufWinLeave" }, {
  group = "CursorLine",
  pattern = "*",
  command = "setlocal nocursorline",
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
