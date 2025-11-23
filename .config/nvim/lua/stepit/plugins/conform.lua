return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.b.autoformat = true
	end,
	keys = {
		{
			"<leader>ci",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "x" },
			desc = "Format Injected Langs",
		},
	},
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			astro = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			go = { "golangci-lint" }, -- "gofmt", "goimports",
			yaml = { "yamlfmt", "prettier" },
			sh = { "shfmt" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			javascript = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			abi = { "prettier" },
			toml = { "taplo" },
			solidity = { "forge_fmt" },
		},
		formatters = {
			injected = {
				options = {
					ignore_errors = true,
					lang_to_ft = {
						go = "markdown",
					},
					lang_to_ext = {
						go = { "prettier" },
					},
				},
			},
		},
		-- formatters = {
		-- 	json = {
		-- 		command = "jq",
		-- 		-- A list of strings, or a function that returns a list of strings
		-- 		-- Return a single string instead of a list to run the command in a shell
		-- 		args = { "'.'", "$FILENAME" },
		-- 		condition = function(self, ctx)
		-- 			return vim.fs.basename(ctx.filename) ~= "*.abi"
		-- 		end,
		-- 	},
		-- },
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
		--
		-- require("conform").formatters.abi = {
		-- 	command = "jq '.'",
		-- }

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

				conform.format({ bufnr = args.buf })
			end,
		})
	end,
}
