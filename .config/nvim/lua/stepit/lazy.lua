local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ import = "stepit.plugins" },
	{ "tpope/vim-surround" },
	-- Amazing for web dev: https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
	{ "mattn/emmet-vim" },
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
require("lazy").setup(plugins, {
	dev = {
		path = "~/Repositories/Nvim/",
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
	change_detection = { notify = false },
})
