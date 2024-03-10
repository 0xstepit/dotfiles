-- Description: allows to mark specific files to fast
-- and focused navigation. Files are marked per project.
return {
	"ThePrimeagen/harpoon",
	name = "Harpoon",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		-- mark file with harpoon
		vim.keymap.set("n", "<leader>aa", mark.add_file)
		-- show harpoon marks
		vim.keymap.set("n", "<leader>am", ui.toggle_quick_menu)
		-- go to next harpoon mark
		vim.keymap.set("n", "<leader>an", ui.nav_next)
		-- go to previous harpoon mark
		vim.keymap.set("n", "<leader>ap", ui.nav_prev)
		-- go to specific mark number
		vim.keymap.set("n", "<leader>a1", function() ui.nav_file(1) end)
		vim.keymap.set("n", "<leader>a2", function() ui.nav_file(2) end)
		vim.keymap.set("n", "<leader>a3", function() ui.nav_file(3) end)
		vim.keymap.set("n", "<leader>a4", function() ui.nav_file(4) end)
		vim.keymap.set("n", "<leader>a5", function() ui.nav_file(5) end)
	end,
}
