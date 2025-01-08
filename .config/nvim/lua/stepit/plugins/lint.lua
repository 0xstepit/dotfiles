return {
  "mfussenegger/nvim-lint",
  name = "Lint",
  event = { "VeryLazy" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {

      markdown = { "markdownlint" },
      sh = { "shellcheck" },
      go = { "golangcilint" },
    }

    local markdownlint_config = vim.fn.resolve(vim.fn.stdpath("config") .. "/.markdownlint.yaml")

    if vim.fn.filereadable(markdownlint_config) == 0 then
      vim.notify("markdownlint config file not found: " .. markdownlint_config, vim.log.levels.WARN)
    else
      lint.linters.markdownlint.args = {
        "--stdin",
        "--config=" .. markdownlint_config,
        "--",
      }
    end

    lint.linters.shellcheck.args = {
      "--severity=warning", -- force to work with zsh
      "--format=json",
      "-",
    }

    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters then
        print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        print("No linters configured for filetype: " .. filetype)
      end
    end, {})

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
