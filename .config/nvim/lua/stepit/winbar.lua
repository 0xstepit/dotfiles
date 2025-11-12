local chevrons = require("stepit.utils.icons").chevrons
local symbols = require("stepit.utils.icons").symbols

local M = {}

-- Highlight groups
local hl_special_dirs = "%#WinBarSpecial#"
local hl_project = "%#Function#"
local hl_path = "%#WinbarPath#"
local hl_file = "%#WinBarFile#"

local path_separator = chevrons.right

---@return string
function M.render()
	-- Get the path and expand variables.
	local path = vim.fs.normalize(vim.fn.expand("%:p"))
	local file = vim.fs.normalize(vim.fn.expand("%:t"))

	if file ~= "." then
		path = vim.fs.normalize(vim.fn.expand("%:p:h")) .. "/"
		file = string.format("%s %s", hl_file, file)
	else
		file = ""
	end

	-- -- No special styling for diff views.
	-- if vim.startswith(path, "diffview") then
	-- 	return string.format(winbar .. "%s", path)
	-- end

	local special_dirs = {
		DOTFILES = vim.env.DOTFILES,
		WORK = vim.env.WORK,
		REPOS = vim.env.REPOS,
	}

	local prefix, prefix_path = "", ""
	for dir_name, dir_path in pairs(special_dirs) do
		if vim.startswith(path, vim.fs.normalize(dir_path)) then
			path = path:gsub("^" .. dir_path, "")
			prefix = dir_name
			break
		end
	end

	if prefix ~= "" then
		path = path:gsub("^" .. prefix_path, "")
		prefix = string.format("%s %s %s %s", hl_special_dirs, symbols.Folder, prefix, path_separator)
	end

	-- Remove leading slash.
	path = path:gsub("^/", "")

	return table.concat({
		prefix,
		table.concat(vim.iter(vim.split(path, "/"))
			:enumerate()
			:map(function(idx, segment)
				if segment == "" then
					return ""
				end
				if idx == 1 then
					return string.format("%s %s %s %s", hl_project, segment, hl_path, path_separator)
				else
					return string.format("%s %s %s", hl_path, segment, path_separator)
				end
			end)
			:totable()),
		file,
	})
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("stepit/winbar", { clear = true }),
	desc = "Attach winbar",
	callback = function(args)
		if
			not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
			and vim.bo[args.buf].buftype == "" -- Normal buffer
			and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
			and not vim.wo[0].diff -- Not in diff mode
		then
			-- %{} indicates an evaluation in the context of the of the window the winbar belongs to.
			vim.wo.winbar = "%{%v:lua.require'stepit.winbar'.render()%}"
		end
	end,
})

return M
