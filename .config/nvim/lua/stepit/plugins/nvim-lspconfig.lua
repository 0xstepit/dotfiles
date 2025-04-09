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
    }

    for _, value in ipairs(servers) do
      utils.configure_server(value, config[value] or {})
    end

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
