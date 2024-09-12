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
  { "tpope/vim-surround" },
  { "mattn/emmet-vim" },
  { "numToStr/Comment.nvim", opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = {
          icon = "● ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = "● ", color = "info" },
        HACK = { icon = "● ", color = "warning" },
        WARN = { icon = "● ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "● ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "● ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "● ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
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
}

require("lazy").setup(spec, opts)
