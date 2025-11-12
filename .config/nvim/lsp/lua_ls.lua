---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			-- Using stylua for formatting.
			format = { enable = true },
			hint = {
				enable = true,
				arrayIndex = "Disable",
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true), -- Make LSP aware of Neovim runtime
				-- library = vim.list_extend({
				-- 	vim.env.VIMRUNTIME,
				-- 	"${3rd}/luv/library",
				-- 	-- Include Neovim runtime to navigate plugins.
				-- }, vim.api.nvim_get_runtime_file("", true)),
			},
		},
	},
}
