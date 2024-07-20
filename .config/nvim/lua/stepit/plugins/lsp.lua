return {
  "neovim/nvim-lspconfig",
  name = "LspConfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "folke/neodev.nvim", opt = {} },
  },
  opts = function()
    return {
      diagnostics = {
        underline = true,
        severity_sort = true,
        virtual_text = {
          source = "if_many",
          prefix = "● ",
        },
      },
    }
  end,
  config = function(_, opts)
    require("neodev").setup {}
    local border = {
      { "╭", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╮", "FloatBorder" },
      { "│", "FloatBorder" },
      { "╯", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╰", "FloatBorder" },
      { "│", "FloatBorder" },
    }

    local handler = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
    }

    -- TODO: floating window above the cursor
    -- vim.lsp.util.make_floating_popup_options(relative="cursor")

    local signs = { Error = "✗ ", Warn = "▲ ", Hint = "! ", Info = "▶ " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Here we configure Mason
    require("mason").setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➞",
          package_uninstalled = "✗",
        },
      },
    }
    local lspconfig = require "lspconfig"
    -- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    lspconfig.lua_ls.setup {
      -- capabilities = lsp_capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    }
    lspconfig.gopls.setup {
      handlers = handler,
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      -- capabilities = lsp_capabilities,
      settings = {
        gopls = {
          ["ui.inlayhint.hints"] = {
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
      init_options = {
        usePlaceholders = true,
      },
    }
    lspconfig.marksman.setup {
      cmd = { "marksman", "server" },
      filetypes = { "markdown", "markdown.mdx" },
      -- capabilities = lsp_capabilities,
      settings = {
        single_file_support = true,
      },
    }
    lspconfig.solidity.setup {
      cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
      filetypes = { "solidity" },
      root_dir = require("lspconfig.util").find_git_ancestor,
      single_file_support = true,
    }

    -- Requires better config:
    lspconfig.bufls.setup {}
    lspconfig.pyright.setup {}
    lspconfig.tsserver.setup {
      -- capabilities = lsp_capabilities,
      filetypes = {
        "javascript",
        "typescript",
      },
    }
    lspconfig.emmet_ls.setup {
      -- capabilities = capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
    }

    -- servers we always want installed
    local ensure_installed = {
      "lua_ls",
      "pyright",
      "gopls",
      "golangci_lint_ls",
      "rust_analyzer",
      "marksman",
      "solidity",
      "bufls",
      "tsserver",
      "html",
      "cssls",
      "tailwindcss",
      "emmet_ls",
    }

    -- Here is where we manage the installation of language servers
    require("mason-lspconfig").setup {
      ensure_installed = ensure_installed,
      -- handlers = handlers,
      automatic_installation = true,
    }

    require("mason-tool-installer").setup {
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "gofumpt",
        "goimports",
      },
      run_on_start = true,
    }

    -- vim.lsp.on_attach_callback = function(client, bufnr)
    --   vim.lsp.inlay_hint(bufnr, true)
    -- end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        opts = { buffer = ev.buf }
        local telescope = require "telescope.builtin"

        opts.desc = "Go to definition"
        vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)

        opts.desc = "Go to reference"
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_reference<CR>", opts)

        opts.desc = "Go to implementation"
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Rename variable"
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Open floating doc for type under the cursor"
        -- calling this twice will move the cursor in the doc floating window.
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Open code actions"
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Singatuire help in insert mode"
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

        opts.desc = "Restart LSP server"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        opts.desc = "Diagnostic go to next"
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)

        opts.desc = "Diagnostic go to previous"
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Diagnostic in float window"
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
      end,
    })
  end,
}
