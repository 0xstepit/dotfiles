local M = {}

local set = vim.keymap.set

-- Default configuration
M.config = {
	author = "stepit",
	date_format = "%Y-%m-%d",
	default_category = "",
	default_tags = {},
	default_to_publish = false,
}

-- Setup function to override defaults
function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	-- Setup keymaps by default unless explicitly disabled
	if opts.setup_keymaps ~= false then
		M.setup_keymaps()
	end
end

function M.new_note(title)
	-- Validate and sanitize input
	if not title or title == "" then
		return { error = true, message = "Title cannot be empty" }
	end
	title = vim.trim(title)
	if title == "" then
		return { error = true, message = "Title cannot be empty or whitespace only" }
	end

	-- Get env vars required for the creation of a new note.
	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		return { error = true, message = "$NOTES environment variable is not set" }
	end

	local inbox = os.getenv("INBOX")
	if not inbox or inbox == "" then
		return { error = true, message = "$INBOX environment variable is not set" }
	end

	title = title:gsub("^%l", string.upper)
	-- Generate slug: remove special chars, convert spaces to hyphens
	local slug = title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-"):gsub("^-+", ""):gsub("-+$", "")
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

	local date = os.date(M.config.date_format)
	local frontmatter = {
		"---",
		string.format("author: %s", M.config.author),
		string.format("title: '%s'", title),
		string.format("slug: '%s'", slug),
		string.format("created: %s", date),
		string.format("modified: %s", date),
		"summary: ''",
		string.format("category: '%s'", M.config.default_category),
		string.format("tags: [%s]", table.concat(M.config.default_tags, ", ")),
		"related: []",
		string.format("to-publish: %s", tostring(M.config.default_to_publish)),
		"---",
		"",
		"", -- Another line where we want to start adding text.
	}

	-- Use pcall for safer file operations
	local ok, file_or_err = pcall(io.open, note_path, "w")
	if not ok or not file_or_err then
		return {
			error = true,
			message = string.format("Failed to create file: %s (%s)", note_path, tostring(file_or_err)),
		}
	end

	local write_ok, write_err = pcall(function()
		file_or_err:write(table.concat(frontmatter, "\n"))
		file_or_err:close()
	end)

	if not write_ok then
		return {
			error = true,
			message = string.format("Failed to write to file: %s (%s)", note_path, tostring(write_err)),
		}
	end

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
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

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
	local date = os.date(M.config.date_format)

	-- Get first 30 lines to account for longer frontmatter
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 30, false)

	-- Check if file starts with frontmatter
	if not lines[1] or not lines[1]:match("^%-%-%-$") then
		return false
	end

	local frontmatter_end = nil
	local modified_line = nil
	local created_line = nil

	-- Find frontmatter boundaries and relevant fields
	for line_num = 2, #lines do
		local line_content = lines[line_num]

		-- Find closing frontmatter delimiter
		if line_content:match("^%-%-%-$") then
			frontmatter_end = line_num
			break
		end

		-- Track modified and created fields
		if line_content:match("^modified:") then
			modified_line = line_num
		elseif line_content:match("^created:") then
			created_line = line_num
		end
	end

	-- If no frontmatter end found, not valid frontmatter
	if not frontmatter_end then
		return false
	end

	-- Update existing modified field
	if modified_line then
		vim.api.nvim_buf_set_lines(bufnr, modified_line - 1, modified_line, false, { "modified: " .. date })
		return true
	end

	-- If no modified field but we have created field, insert after it
	if created_line then
		vim.api.nvim_buf_set_lines(bufnr, created_line, created_line, false, { "modified: " .. date })
		return true
	end

	-- If no created or modified field, insert before closing delimiter
	if frontmatter_end then
		vim.api.nvim_buf_set_lines(
			bufnr,
			frontmatter_end - 1,
			frontmatter_end - 1,
			false,
			{ "modified: " .. date }
		)
		return true
	end

	return false
end

-- Public function to prompt for and create a new note
function M.prompt_new_note()
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
end

-- Default keybinding (can be disabled by not calling this or overriding)
function M.setup_keymaps()
	set("n", "<leader>mn", M.prompt_new_note, { desc = "[M]arkdown [N]ew note" })
end

-- Setup autocmd to auto-update modified date on save
local function setup_autocmds()
	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		return -- Skip autocmd setup if NOTES env var not set
	end

	local group = vim.api.nvim_create_augroup("NotesAutoUpdate", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = notes_dir .. "/**/*.md",
		callback = function(args)
			M.update_modified_in_frontmatter(args.buf)
		end,
		desc = "Auto-update modified date in note frontmatter",
	})
end

setup_autocmds()

-- Setup default keymaps (for backwards compatibility)
-- Users can disable by calling M.setup({ setup_keymaps = false })
M.setup_keymaps()

return M
