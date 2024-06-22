return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	name = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"folke/todo-comments.nvim",
	},
	config = function()
		-- we need to configure both options and keymaps inside config because:
		-- - options are configured using telescope actions
		-- - keymaps are configured using telescope builtin

		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.load_extension("fzf")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				path_display = { "full" },
				fuzzy = true,
				mappings = {
					i = {
						-- Movements
						["<C-k>"] = actions.move_selection_previous, -- move up in Results
						["<C-j>"] = actions.move_selection_next, -- move down in Results
						-- Actions
						["<C-l>"] = actions.select_default,
						["<C-y>"] = actions.select_default,
						["<C-q>"] = actions.close, -- close window
						["<C-c>"] = actions.delete_buffer, -- close buffer
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
			pickers = {
				-- find_files = {
				-- 	theme = "dropdown",
				-- 	show_line = false,
				-- 	previewer = false,
				-- 	disable_devicons = true,
				-- },
				live_grep = {
					layout_config = {
						width = 0.90,
					},
					theme = "dropdown",
					show_line = false,
					disable_devicons = true,
				},
				oldfiles = {
					theme = "dropdown",
					previewer = false,
					disable_devicons = true,
				},
				lsp_references = {
					layout_config = {
						width = 0.90,
					},
					theme = "dropdown",
					show_line = false,
					disable_devicons = true,
				},
				lsp_implementations = {
					layout_config = {
						width = 0.90,
					},
					theme = "dropdown",
					show_line = false,
					disable_devicons = true,
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Fuzzy find git files" })
		vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
		vim.keymap.set("n", "<leader>f<space>", builtin.oldfiles, { desc = "Find old files" })
		vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find lsp references" })
		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		vim.keymap.set(
			"n",
			"<leader>cd",
			":cd %:p:h<CR>:pwd<CR>",
			{ desc = "Change current directory (cwd) for Telescope" }
		)
	end,
}
