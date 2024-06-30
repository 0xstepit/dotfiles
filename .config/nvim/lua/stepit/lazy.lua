local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Folder containing all plugins.
local plugin_path = { import = "stepit.plugins" }

-- Plugins that don't require any config.
local additional_plugins = {
  { "tpope/vim-surround" },
  { "mattn/emmet-vim" },
  { "numToStr/Comment.nvim", opts = {} },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
	"folke/which-key.nvim",
	name = "WhichKey",
	event = "VimEnter",
	opts = {
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "→", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["<leader>a"] = { name = "+harpoon" },
			["<leader>e"] = { name = "+netrw" },
			["<leader>g"] = { name = "+git" },
			["<leader>t"] = { name = "+trouble" },
			["<leader>h"] = { name = "+gitsign" },
			["<leader>f"] = { name = "[F]ind" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}
}

local spec = {
  plugin_path,
  additional_plugins,
}

local opts = {
  -- Path for local plugins.
  dev = {
    path = "~/Repositories/Nvim/",
    patterns = {},
    fallback = false,
  },
  change_detection = { notify = false },
}

require("lazy").setup(spec, opts)
