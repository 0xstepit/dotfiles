return {
  "stevearc/conform.nvim",
  name = "Conform",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  config = function()
  	local conform = require("conform")
  	conform.setup({
  		formatters_by_ft = {
  			lua = { "stylua" },
  			-- Conform will run multiple formatters sequentially
  			python = { "isort", "black" },
  			-- Use a sub-list to run only the first available formatter
  			javascript = { { "prettierd", "prettier" } },
  			json = { "prettier" },
  			yaml = { "prettier" },
  			go = { "gofumpt", "gofmt", "goimports" },
  			rst = { "rustfmt" },
  		},
  		format_on_save = {
  			-- These options will be passed to conform.format()
  			timeout_ms = 500,
  			lsp_fallback = true,
  		},
  	})
  end,
}
