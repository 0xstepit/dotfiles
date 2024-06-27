return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
		workspaces = {
			{
				name = "houze",
				path = "$NOTES/main",
			},
		},
		ui = {
			enable = false,
			-- heckboxes = {
			-- 	[" "] = { char = "X", hl_group = "ObsidianTodo" },
			-- 	["x"] = { char = "X", hl_group = "ObsidianDone" },
			-- 	[">"] = { char = "X", hl_group = "ObsidianRightArrow" },
			-- 	["~"] = { char = "~", hl_group = "ObsidianTilde" },
			-- 	["!"] = { char = "!", hl_group = "ObsidianImportant" },
			-- 	-- Replace the above with this if you don't have a patched font:
			-- 	-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
			-- 	-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
			--
			-- 	-- You can also add more custom ones...
			-- },
		},

		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "Journal/",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y/%m-%B/%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = nil,
		},

		new_notes_location = "./",

		templates = {
			folder = "Templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
			},
		},
		note_frontmatter_func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end

			-- id = note.id,
			local out = { aliases = note.aliases, tags = note.tags }

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},
}
