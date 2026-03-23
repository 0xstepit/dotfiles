-- Helper to close mini.files before opening fzf-lua
local function close_mini_files()
	local ok, mini_files = pcall(require, "mini.files")
	if ok then
		mini_files.close()
	end
end

return {
	"ibhagwan/fzf-lua",
	lazy = false,
	keys = {
		{
			"<leader>ff",
			function()
				close_mini_files()
				require("fzf-lua").files({
					cwd_prompt = false,
				})
			end,
			desc = "[F]ind [F]iles",
		},
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
				local notes_dir = os.getenv("KNOWLEDGE_BASE")
				if not notes_dir or notes_dir == "" then
					return vim.notify("$KNOWLEDGE_BASE environment variable is not set")
				end

				require("fzf-lua").files({
					prompt = require("stepit.utils.icons").symbols.lens .. "    ",
					cwd = notes_dir,
					find_opts = [[-type f \! -path '*/.*' \! -path '*/Deprecated/*']],
					rg_opts = [[--color=never --files -g "!.*" -g "!Deprecated"]],
					fd_opts = [[--color=never --type f --type l --exclude '.*' --exclude Deprecated]],
					-- With these opts we can grep only the file name.
					fzf_opts = {
						["--delimiter"] = "/",
						["--with-nth"] = "-1",
					},
					winopts = {
						fullscreen = false,
						preview = {
							hidden = true,
						},
					},
				})
			end,
			desc = "[F]ind [N]otes",
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
				require("fzf-lua").diagnostics_workspace({
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
			keymap = {
				fzf = {
					["ctrl-a"] = "toggle-all",
				},
			},
			previewers = {
				builtin = {
					syntax_limit_b = 1024 * 100, -- 100KB
				},
			},
		}
	end,
}
