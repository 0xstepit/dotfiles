local icons = require("stepit.utils.icons")

return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
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
  end,
}
