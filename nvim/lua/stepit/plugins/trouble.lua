return {
	"folke/trouble.nvim",
	name = "Trouble",
	-- opts = { use_diagnostic_signs = true },
	keys = {
		{ "<leader>tt", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		{ "<leader>tT", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
		{ "<leader>tq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
	},
	config = function()
		require("trouble").setup({
			icons = false,
			position = "left",
			fold_open = "v", -- icon used for open folds
			fold_closed = ">", -- icon used for closed folds
			indent_lines = false, -- add an indent guide below the fold icons
			signs = {
				error = "error",
				warning = "warn",
				hint = "hint",
				information = "info"
			},
			use_diagnostic_signs = false
		})

		vim.keymap.set("n", "<leader>tn", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end)
		vim.keymap.set("n", "<leader>tp", function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end)
	end,
}
