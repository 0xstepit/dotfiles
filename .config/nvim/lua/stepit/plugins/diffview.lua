return {
	{
		"sindrets/diffview.nvim",
		lazy = false,
		keys = {
			{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "[G]itDiff [H]istory" },
			{
				"<leader>gd",
				function()
					local branch = vim.g.ref_branch

					vim.ui.input({ prompt = "Git ref to diff against: " }, function(input)
						if input and input ~= "" then
							branch = input
						end
					end)

					vim.cmd("DiffviewOpen " .. branch)
				end,
				desc = "[G]it[D]iff [O]pen",
			},
			{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "[G]itDiff [C]lose" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "[G]itDiff [F]ile history" },
		},
		opts = function()
			require("diffview.ui.panel").Panel.default_config_float.border = "rounded"

			return {
				file_panel = {
					listing_style = "tree", -- One of 'list' or 'tree'
					tree_options = { -- Only applies when listing_style is 'tree'
						flatten_dirs = true, -- Flatten dirs that only contain one single dir
						folder_statuses = "never", -- One of 'never', 'only_folded' or 'always'.
					},
					win_config = { -- See |diffview-config-win_config|
						position = "right",
						width = 35,
						win_opts = {},
					},
				},
			}
		end,
	},
}
