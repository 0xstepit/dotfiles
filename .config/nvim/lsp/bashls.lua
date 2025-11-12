---@type vim.lsp.Config
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh" },
	-- settings = {
	-- 	bashIde = {
	-- 		globPattern = "*@(.sh|.inc|.bash|.command)",
	-- 	},
	-- },
	-- single_file_support = true,
}
