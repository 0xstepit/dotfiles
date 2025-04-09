local icons = require("stepit.utils.icons")

local M = {}

-- Define how the UI for the LSP should be. This UI is associated with floating windows create
-- for example pressing the documentation keymap "K".
function M.configure_ui()
  -- NOTE: probably next line can be removed
  -- require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Override the default floating preview window border function to always use rounded borders.
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = icons.get_borders()
    opts.max_height = math.floor(vim.o.lines * 0.4)
    opts.max_width = math.floor(vim.o.columns * 0.4)
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

function M.configure_diagnostic()
  M._set_diagnostic_signs()

  vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    virtual_text = {
      source = "if_many",
      prefix = icons.sign.none,
    },
  })
end

function M._set_diagnostic_signs()
  local diagnostic_kind = {
    Error = icons.diagnostic.error,
    Warn = icons.diagnostic.warn,
    Hint = icons.diagnostic.hint,
    Info = icons.diagnostic.info,
  }
  for type, icon in pairs(diagnostic_kind) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

--- Configures the given server with settings and applying the regular
--- client capabilities (+ the completion ones from nvim-cmp).
---@param name string
---@param settings? table
function M.configure_server(name, settings)
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

  require("lspconfig")[name].setup(
    vim.tbl_deep_extend("error", { capabilities = capabilities, silent = true }, settings or {})
  )
end

--- Sets up LSP keymaps and autocommands for the given buffer and client.
---@param client vim.lsp.Client
---@param buffer integer
function M.on_attach(client, buffer)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = buffer, desc = desc })
  end

  map("<leader>rs", ":LspRestart<CR>", "[R]estart LSP [S]erver")

  map("[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
  map("]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
  map("<leader>cd", vim.diagnostic.open_float, "Diagnostic in float window")
  map("<leader>cq", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")
  map("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, "Previous [E]rror")
  map("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, "Next [E]rror")

  map("<leader>cr", vim.lsp.buf.rename, "[R]ename variable")
  map("<leader>ca", vim.lsp.buf.code_action, "[A]ctions")
  map("<C-s>", vim.lsp.buf.signature_help, "Singature help in insert mode", "i")

  local telescope = require("telescope.builtin")

  if client.name == "solidity_ls_nomicfoundation" then
    map("gd", vim.lsp.buf.definition, "[D]efinition")
    map("gr", vim.lsp.buf.references, "[R]eferences")
    map("gt", vim.lsp.buf.type_definition, "[T]ype definition")
  else
    map("gd", telescope.lsp_definitions, "[D]efinition")
    map("gr", telescope.lsp_references, "[R]eferences")
    map("gt", telescope.lsp_type_definitions, "[T]ype definition")
  end

  if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
      range = true,
    }
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/implementation") then
    map("gi", telescope.lsp_implementations, "[I]mplementation")
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/references") then
    map("gr", telescope.lsp_references, "[R]eference")
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/documentHighlight") then
    local under_cursor_highlights_group = vim.api.nvim_create_augroup("stepit/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = under_cursor_highlights_group,
      -- pattern = { "*.go", "*.lua" },
      desc = "Highlight references under the cursor",
      buffer = buffer,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = under_cursor_highlights_group,
      -- pattern = { "*.go", "*.lua" },
      desc = "Clear highlight references",
      buffer = buffer,
      callback = vim.lsp.buf.clear_references,
    })
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/inlayHint") then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
    end, "[T]oggle inlay [H]ints")
  end
end

return M
