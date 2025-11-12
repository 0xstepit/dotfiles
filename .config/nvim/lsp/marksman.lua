---@type vim.lsp.Config
return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	settings = {
		single_file_support = true,
	},
	root_markers = { ".git" },
}
