-- Description: allows to obtain the link of the selected lines in the repository host.
return {
	"ruifm/gitlinker.nvim",
	name = "Gitlinker",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local gitlinker = require("gitlinker")
		gitlinker.setup({})
		-- Copy repo url
		vim.keymap.set("n", "<leader>gy", function() gitlinker.get_buf_range_url() end)
	end
}
