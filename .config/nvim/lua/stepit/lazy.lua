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
  { "ixru/nvim-markdown" },
  { "google/vim-jsonnet" },
  { "tpope/vim-surround" },
  { "mattn/emmet-vim" },
  { "numToStr/Comment.nvim", opts = {} },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = "● ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "● ", color = "info" },
        NOTE = { icon = "● ", color = "hint", alt = { "INFO" } },
        LEARN = { icon = "● ", color = "warning" },
      },
    },
  },
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
  ui = {
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
}

require("lazy").setup(spec, opts)
