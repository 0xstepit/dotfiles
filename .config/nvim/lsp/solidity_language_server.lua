---@type vim.lsp.Config
return {
	name = "Solidity Language Server",
	cmd = { "solidity-language-server" },
	root_dir = vim.fs.root(0, { "foundry.toml", ".git" }),
	filetypes = { "solidity" },
	root_markers = { "foundry.toml", ".git" },
	on_attach = function(_, _)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.sol" },
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end,
}
