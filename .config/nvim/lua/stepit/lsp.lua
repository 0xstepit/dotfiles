local diagnostic_icons = require("stepit.utils.icons").diagnostic
local methods = vim.lsp.protocol.Methods

---@param client vim.lsp.Client
---@param buffer integer
local function on_attach(client, buffer)
	---@param keys string
	---@param func string|function
	---@param desc string
	---@param mode? string|string[]
	local map = function(keys, func, desc, mode)
		---@type vim.keymap.set.Opts
		local opts = { buffer = buffer, desc = desc }
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, opts)
	end

	-- Diagnostics
	map("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, "Previous [E]rror diagnostic")
	map("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, "Next [E]rror diagnostic")

	map("<leader>cd", vim.diagnostic.open_float, "Show [D]iagnostic")
	map("<leader>fd", vim.diagnostic.setloclist, "Diagnostic [Q]uickfix list")
	map("<leader>wd", vim.diagnostic.setqflist, "File diagnostic")

	-- Code Actions & Refactoring (standardized)
	map("<leader>cr", vim.lsp.buf.rename, "[R]ename symbol")
	map("<leader>cf", vim.lsp.buf.format, "[F]ormat document")

	map("K", vim.lsp.buf.hover, "Hover documentation")

	if client:supports_method(methods.textDocument_codeAction) then
		map("<leader>ca", function()
			vim.lsp.buf.code_action()
		end, "Code [A]ctions", { "n", "x" })
	end

	if client:supports_method(methods.textDocument_references) then
		map("gr", "<cmd>FzfLua lsp_references<cr>", "Go to [R]eferences")
	end

	if client:supports_method(methods.textDocument_typeDefinition) then
		map("gt", "<cmd>FzfLua lsp_typedefs<cr>", "Go to [T]ype definition")
	end

	if client:supports_method(methods.textDocument_documentSymbol) then
		map("<leader>ds", "<cmd>FzfLua lsp_document_symbols<cr>", "[D]ocument [S]ymbols")
	end

	if client:supports_method(methods.textDocument_definition) then
		map("gd", function()
			require("fzf-lua").lsp_definitions({ jump1 = true })
		end, "Go to definition")
		map("gD", function()
			require("fzf-lua").lsp_definitions({ jump1 = false })
		end, "Peek definition")
	end

	if client:supports_method("textDocument/implementation") then
		map("gi", "<cmd>FzfLua lsp_implementations<cr>", "Go to [I]mplementation")
	end

	-- TODO: we could use blink here
	if client:supports_method(methods.textDocument_signatureHelp) then
		map("<C-s>", vim.lsp.buf.signature_help, "Signature help", "i")
	end

	if client:supports_method(methods.textDocument_documentHighlight) then
		local under_cursor_highlights_group = vim.api.nvim_create_augroup("stepit/cursor_highlights", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Highlight references under the cursor",
			buffer = buffer,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Clear highlight references",
			buffer = buffer,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client:supports_method(methods.textDocument_inlayHint) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
		end, "[T]oggle inlay [H]ints")
	end
end

-- vim.keymap.set("n", "gK", function()
-- 	local new_config = not vim.diagnostic.config().virtual_lines
-- 	vim.diagnostic.config({ virtual_lines = new_config })
-- end, { desc = "Toggle diagnostic virtual_lines" })

--  Static LSP configuration.
vim.diagnostic.config({
	virtual_text = {
		source = false,
		update_in_insert = false,
		severity = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
			vim.diagnostic.severity.HINT,
		},
		prefix = "", -- remove the square in front of the text
		format = function(diagnostic)
			return string.format("%s(%s): %s", diagnostic.source, diagnostic.code, diagnostic.message)
		end,
	},
	-- virtual_lines = {
	-- 	current_line = true,
	-- 	severity = {
	-- 		vim.diagnostic.severity.WARN,
	-- 		vim.diagnostic.severity.INFO,
	-- 		vim.diagnostic.severity.HINT,
	-- 	},
	-- },
	severity_sort = true,
})

for level, icon in pairs(diagnostic_icons) do
	local hl = "DiagnosticSign" .. level:sub(1, 1):upper() .. level:sub(2)
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Enable LSP servers.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
			:map(function(file)
				return vim.fn.fnamemodify(file, ":t:r") -- Get file name, remove extension
			end)
			:totable()

		vim.lsp.enable(servers)
	end,
})

-- Hanlde dynamic capabilities registrations
-- Some LSP servers don't advertise all capabilities immediately when they first attach.
-- Instead, they use dynamic registration to add capabilities later
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(e, res, ctx)
	local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

	for bufnr, _ in pairs(client.attached_buffers) do
		on_attach(client, bufnr)
	end

	return register_capability(e, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_custom_keymaps", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		on_attach(client, args.buf)
	end,
})
