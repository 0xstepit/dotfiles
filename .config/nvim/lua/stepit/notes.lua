local M = {}

local set = vim.keymap.set

function M.new_note(title)
	-- Get env vars required for the creation of a new note.
	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		return { error = true, message = "$NOTES environment variable is not set" }
	end

	local inbox = os.getenv("INBOX")
	if not inbox or inbox == "" then
		return { error = true, message = "$INBOX environment variable is not set" }
	end

	local title = title:gsub("^%l", string.upper)
	local slug = title:lower():gsub("%s+", "-")
	local slug_md = slug .. ".md"

	local inbox_dir = table.concat({ notes_dir, "main", inbox }, "/")
	if vim.fn.isdirectory(inbox_dir) == 0 then
		return {
			error = true,
			message = string.format("Inbox directory does not exist: %s", inbox_dir),
		}
	end

	local note_path = table.concat({ inbox_dir, slug_md }, "/")
	if vim.fn.filereadable(note_path) == 1 then
		return { error = true, message = string.format("Note already exists: %s", note_path) }
	end

	local file = io.open(note_path, "w")
	if not file then
		return { error = true, message = string.format("Failed to create file: %s", note_path) }
	end

	local date = os.date("%Y-%m-%d")
	local frontmatter = {
		"---",
		"author: Stefano Francesco Pitton",
		string.format("title: '%s'", title),
		string.format("slug: '%s'", slug),
		string.format("created: %s", date),
		string.format("modified: %s", date),
		"category: ''",
		"tags: []",
		"related: []",
		"to-publish: false",
		"---",
		"",
		string.format("# %s", title),
		"",
		"", -- A line after the title.
		"", -- Another line where we want to start adding text.
	}

	file:write(table.concat(frontmatter, "\n"))
	file:close()

	vim.cmd(string.format("edit %s", note_path))
	local line_count = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_win_set_cursor(0, { line_count, 0 })

	return {
		error = false,
		message = string.format("Successfully created note: %s", title),
	}
end

local function floating_input(opts, on_confirm)
	-- Create buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Calculate centered position
	local width = opts.width or 50
	local height = 1
	local row = math.floor((vim.o.lines - height) / 2) - 1
	local col = math.floor((vim.o.columns - width) / 2)

	-- Create border buffer for title
	local border_buf = vim.api.nvim_create_buf(false, true)

	-- Create the window with border
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " " .. (opts.prompt or "Input") .. " ",
		title_pos = "center",
	})

	-- Configure buffer
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	-- Start in insert mode
	vim.cmd("startinsert")

	local function close_and_callback(input)
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		on_confirm(input)
	end

	-- Handle submission with Enter
	vim.keymap.set("i", "<CR>", function()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local input = lines[1] or ""
		close_and_callback(input)
	end, { buffer = buf, nowait = true })

	-- Handle cancellation with Escape
	vim.keymap.set({ "n", "i" }, "<Esc>", function()
		close_and_callback(nil)
	end, { buffer = buf, nowait = true })

	-- Close on losing focus
	vim.api.nvim_create_autocmd({ "BufLeave" }, {
		buffer = buf,
		once = true,
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			on_confirm(nil)
		end,
	})
end

function M.update_modified_in_frontmatter(bufnr)
	bufnr = bufnr or 0
	local date = os.date("%Y-%m-%d")

	-- Only get first 20 lines (assuming frontmatter is at top)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)

	for line_num, line_content in ipairs(lines) do
		-- Stop if we've passed the frontmatter
		if line_num > 1 and line_content:match("^%-%-%-$") then
			break
		end

		-- Update if we find modified
		if line_content:match("^modified:") then
			vim.api.nvim_buf_set_lines(bufnr, line_num - 1, line_num, false, { "modified: " .. date })
			return true
		end
	end

	return false
end

-- Your keybinding
set("n", "<leader>mn", function()
	floating_input({ prompt = "Note title:", width = 50 }, function(note_title)
		if not note_title or note_title == "" then
			return
		end
		local result = M.new_note(note_title)
		if result.error then
			vim.notify(result.message, vim.log.levels.ERROR)
		else
			vim.notify(result.message, vim.log.levels.INFO)
		end
	end)
end, { desc = "[M]arkdown [N]ew note" })

return M
