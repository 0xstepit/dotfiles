-- Description: powerful tool to use git in nvim.
return {
	"tpope/vim-fugitive",
	name = "Fugitive",

	config = function()
		-- git status
		vim.keymap.set("n", "<leader>gs", ":Git<CR>")
		-- open blame on the left for the entire file.
		-- <leader>gq to quit blame
		vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
		-- git push
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
	end
}
