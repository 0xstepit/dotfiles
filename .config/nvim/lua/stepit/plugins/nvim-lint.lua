return {
  "mfussenegger/nvim-lint",
  event = { "VeryLazy" },
  dev = false,
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      vim = { "vint" },
      markdown = { "codespell", "markdownlint-cli2" },
      sh = { "shellcheck" },
      go = { "codespell", "golangcilint" },
      solidity = { "solhint" },
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      javascriptreact = { "eslint_d" },
    }

    local markdownlint_config = vim.fn.resolve(vim.fn.stdpath("config") .. "/.markdownlint.yaml")
    if vim.fn.filereadable(markdownlint_config) == 0 then
      vim.notify("custom markdownlint config file not found: " .. markdownlint_config, vim.log.levels.WARN)
    else
      local ml2 = lint.linters["markdownlint-cli2"]
      ml2.cmd = "/opt/homebrew/bin/markdownlint-cli2"
      ml2.args = {
        "--config",
        "" .. markdownlint_config,
        "--",
      }
      lint.linters["markdownlint-cli2"] = ml2
    end

    lint.linters.shellcheck.args = {
      "--severity=warning",
      "--format=json",
      "-",
    }

    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      -- We cannot use `local linters = require("lint").get_running()` because linters that
      -- run async, like golangcilint, run and exit and will not be displayed.
      local linters = require("lint").linters_by_ft[filetype]
      local lt = require("lint").linters["golangcilint"]
      print(vim.inspect(lt))

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
