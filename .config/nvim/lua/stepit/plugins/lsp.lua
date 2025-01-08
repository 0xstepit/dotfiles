local icons = require("stepit.icons")
local lsp_config = require("stepit.lsp.config")

return {
  "neovim/nvim-lspconfig",
  name = "LspConfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- 'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Override the default floating preview window border function to always use rounded borders.
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = require("stepit.icons").get_borders()
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = icons.status.ok,
          package_pending = icons.arrow.right,
          package_uninstalled = icons.status.err,
        },
      },
    })

    local lsp_utils = require("stepit.lsp.init")

    lsp_utils.configure_diagnostic()

    lsp_utils.configure_server("vimls", {})
    lsp_utils.configure_server("buf_ls", lsp_config.buf_ls())
    lsp_utils.configure_server("marksman", lsp_config.marksman())
    lsp_utils.configure_server("lua_ls", lsp_config.lua_ls())
    lsp_utils.configure_server("gopls", lsp_config.gopls())

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspConfigGroup", {}),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
          return
        end

        lsp_utils.on_attach(client, args.buffer)
      end,
    })
  end,
}
