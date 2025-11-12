---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			gofumpt = true,
			-- directoryFilters = { "-utils" },
			-- completeUnimported = true,
			semanticTokens = true,
			usePlaceholders = true,
			completeFunctionCalls = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				functionTypeParameters = true,
				constantValues = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				unusedparams = true,
				unusedvariable = true,
				assign = true,
				shadow = false,
				deprecated = true,
				packagecomment = false,
			},
			staticcheck = true,
		},
	},
}
