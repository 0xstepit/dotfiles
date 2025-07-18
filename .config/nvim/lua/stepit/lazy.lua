local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
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

local spec = {
  -- Folder containing all plugins.
  { import = "stepit.plugins" },
  -- Plugins that don't require any config.
  { "junegunn/gv.vim" },
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
  {
    dir = "~/Repositories/NvimPlugin/devnotes.nvim/",
    config = function()
      require("devnotes").setup()

      vim.keymap.set("n", "<leader>md", ":Daily<CR>")
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    enabled = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
      require("hardtime").setup()
      vim.keymap.set("n", "<leader>tw", ":Hardtime toggle<CR>")
    end,
  },
}

-- Opts are used to configure Lazy plugin manager.
local opts = {
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "flow" },
  },
  change_detection = { notify = false },
  dev = {
    path = "~/Repositories/NvimPlugin/",
  },
  ui = {
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
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
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

require("lazy").setup(spec, opts)
