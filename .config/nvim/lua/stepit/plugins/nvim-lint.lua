return {
	"mfussenegger/nvim-lint",
	event = { "VeryLazy" },
	dev = false,
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			vim = { "vint" },
			markdown = { "markdownlint-cli2", "codespell" },
			sh = { "shellcheck" },
			go = { "golangcilint", "codespell" },
			solidity = { "solhint" },
			typescript = { "eslint_d" },
			javascript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			javascriptreact = { "eslint_d" },
		}

		-- local markdownlint_config = vim.fn.resolve(vim.fn.stdpath("config") .. "/.markdownlint.yaml")
		-- if vim.fn.filereadable(markdownlint_config) == 0 then
		--   vim.notify("custom markdownlint config file not found: " .. markdownlint_config, vim.log.levels.WARN)
		-- else
		--   local ml2 = lint.linters["markdownlint-cli2"]
		--   ml2.cmd = "/opt/homebrew/bin/markdownlint-cli2"
		--   ml2.args = {
		--     "--config",
		--     "" .. markdownlint_config,
		--     "--",
		--   }
		--   lint.linters["markdownlint-cli2"] = ml2
		-- end
		--
		-- lint.linters.shellcheck.args = {
		--   "--severity=warning",
		--   "--format=json",
		--   "-",
		-- }
		--
		-- lint.linters.eslint = {
		--   cmd = "npx",
		--   args = {
		--     "eslint_d", -- Will fallback to eslint if eslint_d not available
		--     "--format",
		--     "json",
		--     "--stdin",
		--     "--stdin-filename",
		--     function()
		--       return vim.api.nvim_buf_get_name(0)
		--     end,
		--   },
		--   stdin = true,
		-- }
		--

		-- local golangcilint = require("lint.linters.golangcilint")
		-- golangcilint.args = {
		-- 	"run",
		-- 	"--fix=false",
		-- 	"--show-stats=false",
		-- 	"--output.json.path=stdout",
		-- 	-- Clear any alternative output paths from config file
		-- 	"--output.text.path=",
		-- 	"--output.tab.path=",
		-- 	"--output.html.path=",
		-- }

		vim.api.nvim_create_user_command("LintInfo", function()
			local filetype = vim.bo.filetype
			-- We cannot use `local linters = require("lint").get_running()` because linters that
			-- run async, like golangcilint, run and exit and will not be displayed.
			local linters = require("lint").linters_by_ft[filetype]

			if linters then
				print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))

				for _, v in ipairs(linters) do
					print("Config for: " .. v)
					local lt = require("lint").linters[v]
					print(vim.inspect(lt))
				end
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
