return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
  },
  config = function()
    local utils = require("stepit.lsp.utils")
    local config = require("stepit.lsp.server_config")

    utils.configure_ui()
    utils.configure_diagnostic()

    local servers = {
      "lua_ls",
      "vimls",
      "yamlls",
      "gopls",
      "solidity_ls",
      "buf_ls",
      "marksman",
      "rust_analyzer",
      "pyright",
      "ts_ls",
      "html",
      "cssls",
      "jsonls",
      "bashls",
      "dockerls",
    }

    for _, value in ipairs(servers) do
      utils.configure_server(value, config[value] or {})
    end

    -- https://github.com/Sin-cy/dotfiles/blob/main/nvim/.config/nvim/lua/sethy/core/keymaps.lua#L84-L92
    -- Toggle LSP diagnostics visibility
    local isLspDiagnosticsVisible = true
    vim.keymap.set("n", "<leader>lx", function()
      isLspDiagnosticsVisible = not isLspDiagnosticsVisible
      vim.diagnostic.config({
        virtual_text = isLspDiagnosticsVisible,
        underline = isLspDiagnosticsVisible,
      })
    end, { desc = "Toggle LSP diagnostics" })

    local is_virtual_line = false
    vim.keymap.set("n", "<leader>tvl", function()
      is_virtual_line = not is_virtual_line
      vim.diagnostic.config({
        virtual_text = not is_virtual_line and {
          source = "if_many",
          prefix = require("stepit.utils.icons").sign.none,
        } or false,
        virtual_lines = is_virtual_line,
      })
    end, { desc = "Toggle virtual lines" })

    -- Use LspAttach autocommand to only add keymaps after the language server attaches to
    -- the current buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspConfigGroup", {}),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
          return
        end

        utils.on_attach(client, args.buf)
      end,
    })
  end,
}
