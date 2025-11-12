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
    -- opts.width = math.floor(vim.o.lines * 0.8)
    -- opts.max_height = math.floor(vim.o.lines * 0.8)
    -- opts.max_width = math.floor(vim.o.columns * 0.8)
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
    -- virtual_lines = true,
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
  -- local capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

  if name == "marksman" then
    vim.notify(vim.inspect(settings))
  end
  require("lspconfig")[name].setup(settings)
end

--- Sets up LSP keymaps and autocommands for the given buffer and client.
---@param client vim.lsp.Client
---@param buffer integer
function M.on_attach(client, buffer)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = buffer, desc = desc })
  end

  -- LSP Management
  map("<leader>rs", ":LspRestart<CR>", "[R]estart LSP [S]erver")
  map("<leader>li", ":LspInfo<CR>", "[L]SP [I]nfo")

  -- Diagnostics (standardized across all servers)
  map("[d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
  map("]d", vim.diagnostic.goto_next, "Next [D]iagnostic")
  map("<leader>cd", vim.diagnostic.open_float, "Show [D]iagnostic")
  map("<leader>cq", vim.diagnostic.setloclist, "Diagnostic [Q]uickfix list")
  map("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, "Previous [E]rror")
  map("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, "Next [E]rror")
  map("[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  end, "Previous [W]arning")
  map("]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  end, "Next [W]arning")

  -- Code Actions & Refactoring (standardized)
  map("<leader>cr", vim.lsp.buf.rename, "[R]ename symbol")
  map("<leader>ca", vim.lsp.buf.code_action, "Code [A]ctions")
  map("<leader>cf", vim.lsp.buf.format, "[F]ormat document")
  map("<C-s>", vim.lsp.buf.signature_help, "Signature help", "i")
  map("K", vim.lsp.buf.hover, "Hover documentation")

  local telescope = require("telescope.builtin")

  -- Navigation (using Telescope for better UX, except for specific servers)
  if client.name == "solidity_ls_nomicfoundation" then
    map("gd", vim.lsp.buf.definition, "Go to [D]efinition")
    map("gr", vim.lsp.buf.references, "Go to [R]eferences")
    map("gt", vim.lsp.buf.type_definition, "Go to [T]ype definition")
  else
    map("gd", telescope.lsp_definitions, "Go to [D]efinition")
    map("gr", telescope.lsp_references, "Go to [R]eferences")
    map("gt", telescope.lsp_type_definitions, "Go to [T]ype definition")
    map("gD", vim.lsp.buf.declaration, "Go to [D]eclaration")
  end

  -- Workspace symbols (standardized)
  map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  map("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")

  -- Server-specific optimizations
  if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
      range = true,
    }
  end

  -- Feature-based keymaps (only if server supports them)
  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/implementation") then
    map("gi", telescope.lsp_implementations, "Go to [I]mplementation")
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/documentHighlight") then
    local under_cursor_highlights_group = vim.api.nvim_create_augroup("stepit/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
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

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("textDocument/inlayHint") then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
    end, "[T]oggle inlay [H]ints")
  end

  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("callHierarchy/incomingCalls") then
    map("<leader>ci", telescope.lsp_incoming_calls, "[C]all hierarchy [I]ncoming")
    map("<leader>co", telescope.lsp_outgoing_calls, "[C]all hierarchy [O]utgoing")
  end

  -- Workspace folder management
  ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
  if client:supports_method("workspace/workspaceFolders") then
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove folder")
    map("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist folders")
  end
end

return M
