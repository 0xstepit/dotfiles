local M = {}

local set = vim.keymap.set

-- Default configuration used for notes frontmatter.
M.config = {
	author = "stepit",
	date_format = "%Y-%m-%d",
	default_category = "",
	default_tags = {},
	default_to_publish = false,
}

-- Extract tags from a frontmatter line.
-- TODO: add support for multiline tags.
local function parse_tags_from_line(line)
	local tags = {}

	-- Match YAML array format: tags: [tag1, tag2, tag3]
	local array_match = line:match("^tags:%s*%[(.*)%]")
	if array_match then
		for tag in array_match:gmatch("[^,%s]+") do
			tag = tag:gsub("^['\"]", ""):gsub("['\"]$", "") -- Remove quotes
			if tag ~= "" then
				table.insert(tags, tag)
			end
		end
		return tags
	end

	return tags
end

-- Scan all notes and extract unique tags.
function M.get_all_tags()
	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		return {}
	end

	local tags_set = {}

	-- Use vim.fn.globpath to find all markdown files
	local md_files = vim.fn.globpath(notes_dir, "**/*.md", false, true)

	for _, file_path in ipairs(md_files) do
		local ok, file = pcall(io.open, file_path, "r")
		if ok and file then
			local in_frontmatter = false
			local line_count = 0

			for line in file:lines() do
				line_count = line_count + 1

				-- Check frontmatter boundaries
				if line_count == 1 and line:match("^%-%-%-$") then
					in_frontmatter = true
				elseif in_frontmatter and line:match("^%-%-%-$") then
					break -- End of frontmatter
				elseif in_frontmatter and line:match("^tags:") then
					local tags = parse_tags_from_line(line)
					for _, tag in ipairs(tags) do
						tags_set[tag] = true
					end
				end

				-- Stop after 30 lines just in case.
				if line_count > 30 then
					break
				end
			end

			file:close()
		end
	end

	-- Convert set to sorted array.
	local tags_array = {}
	for tag, _ in pairs(tags_set) do
		table.insert(tags_array, tag)
	end
	table.sort(tags_array)

	return tags_array
end

function M.new_note(title, tags)
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

	local inbox_dir = table.concat({ notes_dir, "main", inbox }, "/")
	if vim.fn.isdirectory(inbox_dir) == 0 then
		return {
			error = true,
			message = string.format("Inbox directory does not exist: %s", inbox_dir),
		}
	end

	-- Create folder for the note
	local note_folder = table.concat({ inbox_dir, slug }, "/")
	if vim.fn.isdirectory(note_folder) == 1 then
		return { error = true, message = string.format("Note folder already exists: %s", note_folder) }
	end

	-- Create the note folder
	vim.fn.mkdir(note_folder, "p")

	-- Note file has the same name as the folder
	local note_path = table.concat({ note_folder, slug .. ".md" }, "/")

	-- Use provided tags or fall back to config defaults
	tags = tags or M.config.default_tags

	-- Format tags for YAML array
	local tags_str = ""
	if tags and #tags > 0 then
		-- Quote tags if they contain spaces or special chars
		local quoted_tags = {}
		for _, tag in ipairs(tags) do
			if tag:match("[%s,]") then
				table.insert(quoted_tags, string.format("'%s'", tag))
			else
				table.insert(quoted_tags, tag)
			end
		end
		tags_str = table.concat(quoted_tags, ", ")
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
		string.format("tags: [%s]", tags_str),
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

-- Tag selector using fzf-lua
local function tag_selector(available_tags, on_confirm)
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed. Install it to use tag selection.", vim.log.levels.ERROR)
		on_confirm(nil)
		return
	end

	-- Create a copy of available tags and add special entry for custom tags
	local items = vim.tbl_extend("force", {}, available_tags)
	table.insert(items, 1, "+ Add custom tag...")

	fzf.fzf_exec(items, {
		prompt = "Select Tags> ",
		multi = true,
		fzf_opts = {
			["--multi"] = "",
			["--bind"] = "ctrl-a:toggle-all",
			["--header"] = "Tab: multi-select | Ctrl-A: toggle all | Select '+' to add custom tags",
			["--no-sort"] = "", -- Keep tags in order
		},
		actions = {
			["default"] = function(selected)
				if not selected then
					-- User cancelled
					on_confirm(nil)
					return
				end

				local tags = {}
				local needs_custom_input = false

				-- Process selections
				for _, item in ipairs(selected) do
					if item == "+ Add custom tag..." then
						needs_custom_input = true
					else
						table.insert(tags, item)
					end
				end

				-- If user selected custom tag option, show input
				if needs_custom_input then
					floating_input({ prompt = "Custom tag(s) (comma-separated):", width = 50 }, function(input)
						if input and input ~= "" then
							-- Split by comma and add each tag
							for tag_raw in input:gmatch("[^,]+") do
								local tag = vim.trim(tag_raw):gsub("%s+", "-"):lower()
								if tag ~= "" and not vim.tbl_contains(tags, tag) then
									table.insert(tags, tag)
								end
							end
						end
						table.sort(tags)
						on_confirm(tags)
					end)
				else
					-- No custom tags needed, return selections
					if #selected == 0 then
						on_confirm({}) -- Empty selection is valid
					else
						table.sort(tags)
						on_confirm(tags)
					end
				end
			end,
		},
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
		vim.api.nvim_buf_set_lines(bufnr, frontmatter_end - 1, frontmatter_end - 1, false, { "modified: " .. date })
		return true
	end

	return false
end

-- Find and open existing note
function M.find_note()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
		return
	end

	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		vim.notify("$NOTES environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local inbox = os.getenv("INBOX")
	if not inbox or inbox == "" then
		vim.notify("$INBOX environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local resources = os.getenv("RESOURCES")
	if not resources or resources == "" then
		vim.notify("$RESOURCES environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local main_notes_dir = vim.fs.joinpath(notes_dir, "main")
	local inbox_dir = vim.fs.joinpath(main_notes_dir, inbox)
	local resources_dir = vim.fs.joinpath(main_notes_dir, resources)

	-- Build fd command to search for note folders (directories)
	local fd_cmd = string.format(
		"fd --type d --maxdepth 1 . %s %s",
		vim.fn.shellescape(inbox_dir),
		vim.fn.shellescape(resources_dir)
	)

	-- Use fzf-lua with custom fd command
	fzf.fzf_exec(fd_cmd, {
		prompt = "Find Note> ",
		file_icons = true,
		git_icons = false,
		fzf_opts = {
			["--header"] = "Select a note to open",
		},
		actions = {
			["default"] = function(selected)
				if selected and #selected > 0 then
					local folder = selected[1]
					local basename = vim.fn.fnamemodify(folder, ":t")
					local note_path = vim.fs.joinpath(folder, basename .. ".md")
					vim.cmd(string.format("edit %s", note_path))
				end
			end,
		},
	})
end

-- Create new note with tag selection from a given title
local function create_note_with_title(note_title)
	if not note_title or note_title == "" then
		return
	end

	-- Get tags and create note
	local available_tags = M.get_all_tags()
	tag_selector(available_tags, function(selected_tags)
		if selected_tags == nil then
			-- User cancelled
			return
		end

		-- Create note with title and tags
		local result = M.new_note(note_title, selected_tags)
		if result.error then
			vim.notify(result.message, vim.log.levels.ERROR)
		else
			vim.notify(result.message, vim.log.levels.INFO)
		end
	end)
end

-- Search notes with option to create new note from search query
function M.create_note()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
		return
	end

	local notes_dir = os.getenv("NOTES")
	if not notes_dir or notes_dir == "" then
		vim.notify("$NOTES environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local inbox = os.getenv("INBOX")
	if not inbox or inbox == "" then
		vim.notify("$INBOX environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local main_notes_dir = vim.fs.joinpath(notes_dir, "main")
	local inbox_dir = vim.fs.joinpath(main_notes_dir, inbox)
	local resources_dir = vim.fs.joinpath(main_notes_dir, "resources")

	-- Build fd command to search for note folders (directories)
	local fd_cmd = string.format(
		"fd --type d --maxdepth 1 . %s %s",
		vim.fn.shellescape(inbox_dir),
		vim.fn.shellescape(resources_dir)
	)

	-- Use fzf-lua with custom fd command
	fzf.fzf_exec(fd_cmd, {
		prompt = "Find or Create Note> ",
		file_icons = true,
		git_icons = false,
		fzf_opts = {
			["--header"] = "Enter: open selected | Ctrl-N: create new note with query text",
		},
		actions = {
			["default"] = function(selected)
				-- Default action: open the selected folder's note file
				if selected and #selected > 0 then
					local folder = selected[1]
					local basename = vim.fn.fnamemodify(folder, ":t")
					local note_path = vim.fs.joinpath(folder, basename .. ".md")
					vim.cmd(string.format("edit %s", note_path))
				end
			end,
			["ctrl-n"] = function(_, opts)
				-- Create new note using the current query as title
				local query = opts.last_query or ""
				if query == "" then
					vim.notify("Enter a search query to create a new note", vim.log.levels.WARN)
					return
				end
				create_note_with_title(query)
			end,
		},
	})
end

-- Move image to note folder and insert markdown reference
function M.move_image_to_note()
	local current_file = vim.fn.expand("%:p")

	-- Check if current file is in notes directory
	local notes_dir = os.getenv("NOTES")
	if not notes_dir or not current_file:match("^" .. vim.pesc(notes_dir)) then
		vim.notify("Current file is not in notes directory", vim.log.levels.ERROR)
		return
	end

	-- Get the note folder (parent directory of the .md file)
	local note_folder = vim.fn.expand("%:p:h")

	-- Get selected text (visual mode)
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 0 then
		vim.notify("No text selected. Select the image path first.", vim.log.levels.WARN)
		return
	end

	-- Get the selected text
	local image_path
	if #lines == 1 then
		image_path = lines[1]:sub(start_pos[3], end_pos[3])
	else
		-- Multi-line selection - join lines
		image_path = table.concat(lines, "")
	end

	image_path = vim.trim(image_path)
	if image_path == "" then
		vim.notify("Selected text is empty", vim.log.levels.WARN)
		return
	end

	-- Debug: Show captured path
	print("DEBUG - Captured path: '" .. image_path .. "' (length: " .. #image_path .. ")")

	-- Expand path (handles ~ and environment variables)
	local expanded_path = vim.fn.expand(image_path)
	print("DEBUG - Expanded path: '" .. expanded_path .. "'")

	-- Normalize path (handles spaces and special characters)
	local normalized_path = vim.fs.normalize(expanded_path)
	print("DEBUG - Normalized path: '" .. normalized_path .. "'")

	-- Check if file exists
	if vim.fn.filereadable(normalized_path) == 0 then
		vim.notify("Image file not found: '" .. normalized_path .. "'", vim.log.levels.ERROR)
		return
	end

	image_path = normalized_path

	-- Get original filename
	local original_filename = vim.fn.fnamemodify(image_path, ":t")

	-- Prompt for new filename (default to original)
	local new_filename = vim.fn.input("Image name (Enter to keep): ", original_filename)
	if not new_filename or new_filename == "" then
		new_filename = original_filename
	end

	local dest_path = vim.fs.joinpath(note_folder, new_filename)

	-- Check if destination already exists
	if vim.fn.filereadable(dest_path) == 1 then
		local overwrite = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 2)
		if overwrite ~= 1 then
			return
		end
	end

	-- Move the file
	local success = vim.fn.rename(image_path, dest_path)
	if success == 0 then
		vim.notify("Image moved to: " .. dest_path, vim.log.levels.INFO)

		-- Replace selected text with markdown image reference
		local alt_text = new_filename:gsub("%.%w+$", "") -- Remove extension for alt text
		local image_ref = string.format("![%s](%s)", alt_text, new_filename)

		-- Replace the selection with the markdown reference
		vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], { image_ref })

		-- Move cursor after inserted text
		vim.api.nvim_win_set_cursor(0, { start_pos[2], start_pos[3] - 1 + #image_ref })
	else
		vim.notify("Failed to move image", vim.log.levels.ERROR)
	end
end

-- Default keybindings (can be disabled by not calling this or overriding)
function M.setup_keymaps()
	set("n", "<leader>mf", M.find_note, { desc = "[M]arkdown [F]ind note" })
	set("n", "<leader>mn", M.create_note, { desc = "[M]arkdown [N]ew note" })
	set("v", "<leader>mi", M.move_image_to_note, { desc = "[M]arkdown [I]mage - move to note folder" })
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
