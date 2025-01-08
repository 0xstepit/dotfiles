return {
  "stevearc/conform.nvim",
  name = "Conform",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint" },
      go = { "gofumpt", "gofmt", "goimports" },
      -- python = { 'isort', 'black' },
      -- -- Use a sub-list to run only the first available formatter
      -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- json = { 'prettier' },
      -- yaml = { 'prettier' },
      -- rst = { 'rustfmt' },
      -- solidity = { "prettier", "solhint" },
    },
    format_on_save = function()
      if not vim.g.autoformat then
        return nil
      end

      return {
        -- We want to run lsp formatter if no specific formatter is available.
        lsp_format = "fallback",
        timeout_ms = 500,
      }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
  init = function()
    vim.g.autoformat = true
  end,
}
