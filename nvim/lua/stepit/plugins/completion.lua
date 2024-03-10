return {
	"hrsh7th/nvim-cmp",
	name = "Completion",
	event = "InsertEnter",
	dependencies = {
		-- Autocompletion
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",

		'saadparwaiz1/cmp_luasnip',

		-- Snippets
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",

		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		-- used to display cmp info
		local lspkind = require('lspkind')
		local luasnip = require('luasnip')

		require("luasnip.loaders.from_vscode").lazy_load()

		-- when moving across possible autocompletions they are not
		-- inserted in the code until selected.
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		-- https://github.com/mrcjkb/nvim/blob/master/nvim/plugin/completion.lua
		local function has_words_before()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
		end

		local sources = {
			{ name = "path" },
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = 'buffer' },
			{ name = "luasnip" },
			-- { name = "crates" },
		}
		cmp.setup({
			formatting = {
				format = lspkind.cmp_format {
					mode = 'text',
					with_text = true,
					maxwidth = 50,
					ellipsis_char = '...',
					menu = {
						path = '[PATH]',
						nvim_lsp = '[NLSP]',
						buffer = '[BUF]',
						luasnip = '[LSNIP]'
					},
				},
			},
			-- snippet.expand is required
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = {
				-- `i` = insert mode, `c` = command mode, `s` = select mode
				-- fallback: it is used just because suggested by the doc.

				-- Scroll documentations
				["<C-b>"] = cmp.mapping.scroll_docs(4),
				["<C-f>"] = cmp.mapping.scroll_docs(-4),

				-- Simple movement in completion
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
				["<Tab>"] = cmp.mapping.select_next_item(cmp_select),

				-- Confirm selection
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				['<CR>'] = cmp.mapping.confirm({ select = true }),

				-- Multipurpose mappings
				['<C-n>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { 'i', 'c', 's' }),
				['<C-p>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 'c', 's' }),
			},
			sources = cmp.config.sources(sources)
		})
	end
}
