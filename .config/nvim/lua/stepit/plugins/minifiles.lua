return {
	{
		"nvim-mini/mini.files",
		enabled = true,
		init = function()
			-- Auto-open mini.files when starting Neovim with a directory
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local arg = vim.fn.argv(0)
					if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
						require("mini.files").open(arg)
					end
				end,
			})

		end,
		keys = {
			{
				"-",
				function()
					local bufname = vim.api.nvim_buf_get_name(0)
					local path = vim.fn.fnamemodify(bufname, ":p")

					-- Noop if the buffer isn't valid.
					if path and vim.uv.fs_stat(path) then
						require("mini.files").open(bufname, false)
					end
				end,
				desc = "File explorer",
			},
		},
		opts = {
			-- Disable default explorer to prevent BufEnter autocmd from reopening
			options = {
				use_as_default_explorer = false,
			},
			mappings = {
				show_help = "?",
				synchronize = "<leader>w",
				close = "<C-q>",
				go_in_plus = "<cr>",
				go_out_plus = "<tab>",
			},
		},
	},
}
