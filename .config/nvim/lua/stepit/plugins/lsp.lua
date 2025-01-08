return {
  'neovim/nvim-lspconfig',
  name = 'LspConfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'folke/neodev.nvim', opt = {} },
  },
  opts = function()
    return {
      diagnostics = {
        underline = true,
        severity_sort = true,
        float = { border = 'rounded' },
        virtual_text = {
          source = 'if_many',
          prefix = '● ',
        },
      },
    }
  end,
  config = function(_, opts)
    require('neodev').setup({})
    local border = {
      { '╭', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╮', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '╯', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╰', 'FloatBorder' },
      { '│', 'FloatBorder' },
    }

    -- 'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Override the default floating preview window border function to always use rounded borders.
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- TODO: floating window above the cursor
    -- vim.lsp.util.make_floating_popup_options(relative="cursor")

    local signs = { Error = '', Warn = '', Hint = '', Info = '' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Here we configure Mason
    require('mason').setup({
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➞',
          package_uninstalled = '✗',
        },
      },
    })
    local lspconfig = require('lspconfig')

    lspconfig.lua_ls.setup({
      -- capabilities = lsp_capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })
    lspconfig.gopls.setup({
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      -- capabilities = lsp_capabilities,
      settings = {
        gopls = {
          ['ui.inlayhint.hints'] = {
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
          },
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            unusedvariable = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })
    lspconfig.marksman.setup({
      cmd = { 'marksman', 'server' },
      filetypes = { 'markdown', 'markdown.mdx' },
      -- capabilities = lsp_capabilities,
      settings = {
        single_file_support = true,
      },
    })
    lspconfig.solidity.setup({
      cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
      filetypes = { 'solidity' },
      root_dir = require('lspconfig.util').find_git_ancestor,
      single_file_support = true,
    })

    -- lspconfig.solidity_ls.setup {
    --   filetypes = { "solidity" },
    --   root_dir = lspconfig.util.root_pattern("hardhat.config.*", ".git"),
    -- }
    lspconfig.jsonnet_ls.setup({
      settings = {
        ext_vars = {
          foo = 'bar',
        },
        formatting = {
          -- default values
          Indent = 2,
          MaxBlankLines = 2,
          StringStyle = 'single',
          CommentStyle = 'slash',
          PrettyFieldNames = true,
          PadArrays = false,
          PadObjects = true,
          SortImports = true,
          UseImplicitPlus = true,
          StripEverything = false,
          StripComments = false,
          StripAllButComments = false,
        },
      },
    })

    -- local function get_python_path()
    --   -- local venv_path = vim.fn.trim(vim.fn.system "poetry env info -p")
    --   -- return venv_path .. "/bin/python"
    --   return "/Users/stepit/Repositories/Blockchain/Mantra/mantra-py/venv/bin/python3"
    -- end
    -- Requires better config:
    lspconfig.bufls.setup({})
    lspconfig.pyright.setup({
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = true,
          },
          -- pythonPath = get_python_path(),
        },
      },
    })
    lspconfig.ts_ls.setup({})
    lspconfig.emmet_ls.setup({
      -- capabilities = capabilities,
      filetypes = {
        'html',
        'typescriptreact',
        'javascriptreact',
        'css',
        'sass',
        'scss',
        'less',
        'svelte',
      },
    })

    -- servers we always want installed
    local ensure_installed = {
      'lua_ls',
      'pyright',
      'gopls',
      'golangci_lint_ls',
      'rust_analyzer',
      'marksman',
      'solidity_ls',
      'bufls',
      'ts_ls',
      'html',
      'cssls',
      'tailwindcss',
      'emmet_ls',
    }

    -- Here is where we manage the installation of language servers
    require('mason-lspconfig').setup({
      ensure_installed = ensure_installed,
      -- handlers = handlers,
      automatic_installation = true,
    })

    require('mason-tool-installer').setup({
      ensure_installed = {
        'prettier',
        'stylua',
        'isort',
        'black',
        'gofumpt',
        'goimports',
      },
      run_on_start = true,
    })

    -- vim.lsp.on_attach_callback = function(client, bufnr)
    --   vim.lsp.inlay_hint(bufnr, true)
    -- end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        opts = { buffer = ev.buf }
        local telescope = require('telescope.builtin')

        opts.desc = 'Go to definition'
        vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)

        opts.desc = 'Go to declaration'
        vim.keymap.set('n', 'gD', '<cmd>Telescope lsp_declarations<CR>', opts)

        opts.desc = 'Go to reference'
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_reference<CR>', opts)

        opts.desc = 'Go to implementation'
        vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

        opts.desc = 'Rename variable'
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)

        opts.desc = 'Open floating doc for type under the cursor'
        -- calling this twice will move the cursor in the doc floating window.
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        opts.desc = 'Open code actions'
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        opts.desc = 'Singatuire help in insert mode'
        vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)

        opts.desc = 'Restart LSP server'
        vim.keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts)

        opts.desc = 'Diagnostic go to next'
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)

        opts.desc = 'Diagnostic go to previous'
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)

        opts.desc = 'Diagnostic in float window'
        vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, opts)

        opts.desc = 'Open diagnostic [Q]uickfix list'
        vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, opts)
      end,
    })
  end,
}
