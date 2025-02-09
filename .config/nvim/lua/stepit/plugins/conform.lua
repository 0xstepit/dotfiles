return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.g.autoformat = true
    vim.b.autoformat = true
  end,
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint" },
      json = { "prettier" },
      go = { "gofumpt", "gofmt", "goimports" },
      -- python = { 'isort', 'black' },
      -- -- use a sub-list to run only the first available formatter
      -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- json = { 'prettier' },
      -- yaml = { 'prettier' },
      -- rst = { 'rustfmt' },
      -- solidity = { "prettier", "solhint" },
    },
    -- log_level = vim.log.levels.DEBUG,
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    -- local prettier_config = vim.fn.resolve(vim.fn.stdpath("config") .. "/.prettierrc.toml")
    -- if vim.fn.filereadable(prettier_config) == 0 then
    --   print("errror")
    --   vim.notify("prettier config file not found: " .. prettier_config, vim.log.levels.warn)
    -- else
    --   for n, _ in ipairs(conform.formatters) do
    --     print(n)
    --   end
    --   local prt = conform.formatters["prettier"]
    --   if not prt then
    --     print("Not here")
    --   else
    --     prt.args = {
    --       args = { "--config", "" .. prettier_config },
    --     }
    --     -- These can also be set directly
    --     conform.formatters.prettier = prt
    --   end
    -- end

    vim.keymap.set("n", "<leader>tf", function()
      local active = vim.b.autoformat
      if active == false then
        vim.notify("Enabling autoformat on save...", vim.log.levels.INFO)
        vim.b.autoformat = true
      else
        vim.notify("Disabling autoformat on save...", vim.log.levels.INFO)
        vim.b.autoformat = false
      end
    end, { desc = "[T]oggle buffer [F]ormatting" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if not vim.g.autoformat or vim.b[args.buf].autoformat == false then
          return nil
        end

        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
}
