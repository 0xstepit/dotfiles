local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

---@type LazySpec
local spec = {
	-- Folder containing all plugins.
	{ import = "stepit.plugins" },
	-- {
	--   "stevearc/oil.nvim",
	--   opts = require("stepit.new-plugins.oil").opts,
	--   config = require("stepit.new-plugins.oil").config,
	-- },
	-- {
	--   dir = "~/Repositories/Nvim/present.nvim/",
	--   config = function()
	--     require("present").setup()
	--   end,
	-- },
	-- {
	-- 	dir = "~/Repositories/NvimPlugin/devnotes.nvim/",
	-- 	config = function()
	-- 		require("devnotes").setup()
	-- 		vim.keymap.set("n", "<leader>md", ":Daily<CR>")
	-- 	end,
	-- },
}

---@type LazyConfig
local opts = {
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "flow" },
	},
	change_detection = { notify = false },
	dev = { path = "~/Repositories/NvimPlugin/" },
	ui = {
		border = "rounded",
		icons = {
			cmd = " ",
			config = "",
			debug = "● ",
			event = " ",
			favorite = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"netrw",
				"netrwPlugin",
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}

require("stepit.globals")
require("stepit.options")
require("stepit.keymaps")
require("stepit.autocommands")
require("stepit.notes")
require("stepit.lsp")
require("stepit.winbar")
require("stepit.statusline")
require("stepit.filetype")

require("lazy").setup(spec, opts)
