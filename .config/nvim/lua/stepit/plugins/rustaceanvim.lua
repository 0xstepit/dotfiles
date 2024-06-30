return {
  "mrcjkb/rustaceanvim",
  version = "^4",
  name = "Rustacean",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {},
    },
  },
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      inlay_hints = {},
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = function(client, bufnr)
          require("lsp-inlayhints").on_attach(client, bufnr)
          vim.api.nvim_exec([[hi LspInlayHint guifg=gray guibg=NONE ]], false)
          require("lsp-inlayhints").show()
        end,
        default_settings = {
          -- https://rust-analyzer.github.io/manual.html#configuration
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
    }
  end,
}
