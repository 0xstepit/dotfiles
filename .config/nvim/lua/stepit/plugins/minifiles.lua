return {
	{
		"nvim-mini/mini.files",
		enabled = true,
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
