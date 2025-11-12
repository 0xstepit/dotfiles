return {
	"ibhagwan/fzf-lua",
	lazy = false,
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "[F]ind [F]iles" },
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles({
					cwd_only = true,
					include_current_session = true, -- includes files visited during current session.
				})
			end,
			desc = "[F]ind [O]ld files",
		},
		{
			"<leader>fn",
			function()
				local notes_dir = os.getenv("NOTES")
				if not notes_dir or notes_dir == "" then
					return vim.notify("$NOTES environment variable is not set")
				end

				require("fzf-lua").files({
					prompt = require("stepit.utils.icons").symbols.lens .. " Notes ",
					cwd = vim.fs.joinpath(notes_dir, "main"),
					find_opts = [[-type f \! -path '*/.git/*' \! -path '*/Deprecated/*' \! -path '*/.obsidian/*']],
					rg_opts = [[--color=never --hidden --files -g "!.git" -g "!Deprecated" -g "!.obsidian"]],
					fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude Deprecated --exclude .obsidian]],
				})
			end,
			desc = "[F]ind [F]iles",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps({})
			end,
			desc = "[F]ind [K]eymaps",
		},
		{ "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "[F]ind [G]rep" },
		{ "<leader>fob", "<cmd>FzfLua buffers<cr>", desc = "[F]ind [B]uffers" },

		{ "<leader>fgb", "<cmd>FzfLua git_branches<cr>", desc = "[F]ind [G]it [B]ranches" },

		{ "<leader>fdd", "<cmd>FzfLua diagnostics_document<cr>", desc = "[F]ind [D]iagnostics [D]ocument" },
		{
			"<leader>fdw",
			function()
				FzfLua.diagnostics_workspace({
					fzf_opts = {
						["--pointer"] = "┃",
					},
				})
			end,
			desc = "[F]ind [D]iagnostics [W]orkspace",
		},

		{ "<leader>fch", "<cmd>FzfLua highlights<cr>", desc = "[F]ind [C]olor [H]ighlights" },
	},
	opts = function()
		require("fzf-lua").register_ui_select()

		return {
			files = {
				cwd_prompt = false,
			},
			keymap = {
				fzf = {
					["ctrl-a"] = "toggle-all",
				},
			},
			-- actions = {
			-- 	files = {
			-- 		["ctrl-q"] = actions.file_sel_to_qf,
			-- 	},
			-- },
			previewers = {
				builtin = {
					syntax_limit_b = 1024 * 100, -- 100KB
				},
			},
		}
	end,
}
