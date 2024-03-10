return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	name = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
	},
	config = function()
		-- we need to configure both options and keymaps inside config because:
		-- - options are configured using telescope actions
		-- - keymaps are configured using telescope builtin

		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				fuzzy = true,
				mappings = {
					i = {
						-- move up in Results
						["<C-k>"] = actions.move_selection_previous,
						-- move down in Results
						["<C-j>"] = actions.move_selection_next,
						-- move up in Results
						["<C-y>"] = actions.select_default,
						-- close window
						["<C-q>"] = actions.close,
						-- close buffer
						["<C-c>"] = actions.delete_buffer,
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
				find_files = {
					theme = "dropdown",
					show_line = false,
					previewer = false,
					disable_devicons = true
				},
				find_grep = {
					theme = "dropdown",
					show_line = false,
					disable_devicons = true
				},
				buffers = {
					theme = "dropdown",
					previewer = false,
					disable_devicons = true
				},
				lsp_references = {
					show_line = false
				}
			}
		})

		-- change current directory for Telescope
		vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>")

		-- keymaps
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files)
		vim.keymap.set("n", "<leader>fg", builtin.git_files)
		vim.keymap.set("n", "<leader>fs", builtin.live_grep)
		vim.keymap.set("n", "<leader><space>", builtin.buffers)
		vim.keymap.set("n", "<leader>gr", builtin.lsp_references)
	end,
}
