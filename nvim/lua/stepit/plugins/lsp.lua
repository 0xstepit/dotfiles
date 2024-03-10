return {
	"neovim/nvim-lspconfig",
	name = "LspConfig",
	lazy = false,
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
	},

	config = function()
		-- Here we configure Mason
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			}
		})


		local handlers = {

			["lua_ls"] = function()
				local lspconfig = require("lspconfig")
				lspconfig.lua_ls.setup {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }
							}
						}
					}
				}
			end,

			pyright = function()
				require("lspconfig").pyright.setup({
					cmd = { "pyright-langserver", "--stdio" },
					settings = {
						{
							python = {
								analysis = {
									autoSearchPaths = true,
									diagnosticMode = "openFilesOnly",
									useLibraryCodeForTypes = true
								}
							}
						}
					}
				})
			end,

			-- Go configuration
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
			["gopls"] = function()
				require("lspconfig").gopls.setup({
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
								unusedvariable = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
				})
			end,

			["marksman"] = function()
				require("lspconfig").marksman.setup({
					cmd = { "marksman", "server" },
					filetypes = { "markdown", "markdown.mdx" },
					settings = {
						single_file_support = true,
					},
				})
			end,
		}

		-- servers we always want installed
		local ensure_installed = {
			"lua_ls",
			"pyright",
			"gopls",
			"golangci_lint_ls",
			"rust_analyzer",
			"marksman",
		}

		-- Here is where we manage the installation of language servers
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			handlers = handlers,
			automatic_installation = true,
		})

		-- go to next diagnostic
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
		-- go to previous diagnostic
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)
		-- open diagnostic message in float window
		vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				-- -- Enable completion triggered by <c-x><c-o>
				-- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				-- go to definition
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				-- go to reference
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				-- go to implementation
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				-- rename
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				-- visualize docstring
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				-- open code action
				vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
				-- obtain signature info in insert mode
				vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
				vim.keymap.set('n', '<leader>f', function()
					vim.lsp.buf.format { async = true }
				end, opts)
			end,
		})
	end
}
