local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Spec is used to configure plugins.
local spec = {
  -- Folder containing all plugins.
  { import = 'stepit.plugins' },
  -- Plugins that don't require any config.
  {},
}

-- Opts are used to configure Lazy plugin managere.
local opts = {
  -- Path for local plugins.
  dev = {
    path = '~/Repositories/Nvim/',
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
  change_detection = { notify = false },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        'gzip',
        -- 'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

require('lazy').setup(spec, opts)
