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
			abi = { "prettier" },
			astro = { "prettier" },
			css = { "prettier" },
			lua = { "stylua" },
			go = { "golangci-lint" },
			javascript = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			solidity = { "forge_fmt" },
			toml = { "taplo" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "yamlfmt", "prettier" },
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
	},
	config = function(_, opts)
		local conform = require("conform")

		conform.setup(opts)

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
