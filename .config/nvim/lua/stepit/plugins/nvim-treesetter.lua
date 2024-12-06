return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 3,
          multiline_threshold = 1,
          min_window_height = 20,
        },
        keys = {
          {
            '[c',
            function()
              require('treesitter-context').go_to_context(vim.v.count1)
            end,
            { desc = 'Jump to upper context' },
          },
        },
      },
    },
    opts = {
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'dockerfile',
        'html',
        'javascript',
        'json',
        'jsonnet',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'toml',
        'typescript',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'solidity',
        'rust',
        'vim',
        'vimdoc',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = false,
        },
      },
      highlight = { enable = true },
    },
    config = function(_, opts)
      local configs = require('nvim-treesitter.configs')
      configs.setup(opts)
    end,
  },
}
