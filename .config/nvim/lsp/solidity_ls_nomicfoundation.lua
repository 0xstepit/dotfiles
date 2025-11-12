---@type vim.lsp.Config
return {
	cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
	single_file_support = true,
	filetypes = { "solidity" },
	root_markers = { "foundry.toml", ".git" },
}
