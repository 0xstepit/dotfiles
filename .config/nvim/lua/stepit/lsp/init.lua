local M = {}

--- Configures the given server with settings and applying the regular
--- client capabilities (+ the completion ones from nvim-cmp).
---@param server_name string
---@param settings? table
function M.configure_server(server_name, settings)
  -- FIXME: add after cmp
  -- local function capabilities()
  --     return vim.tbl_deep_extend(
  --         'force',
  --         vim.lsp.protocol.make_client_capabilities(),
  --         -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
  --         require('cmp_nvim_lsp').default_capabilities()
  --     )
  -- end

  require("lspconfig")[server_name].setup(
    vim.tbl_deep_extend(
      "error",
      { capabilities = vim.lsp.protocol.make_client_capabilities(), silent = true },
      settings or {}
    )
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

  local telescope = require("telescope.builtin")

  map("gd", telescope.lsp_definitions, "[D]efinition")
  map("gr", telescope.lsp_references, "[R]eference")
  map("gi", telescope.lsp_implementations, "[I]mplementation")
  map("gr", telescope.lsp_references, "[R]eferences")
  map("gt", telescope.lsp_type_definitions, "[T]ype definition")

  map("<leader>cr", vim.lsp.buf.rename, "[R]ename variable")
  map("<leader>ca", vim.lsp.buf.code_action, "[A]ctions")
  map("K", vim.lsp.buf.hover, "Open floating doc for type under the cursor")
  map("<C-s>", vim.lsp.buf.signature_help, "Singature help in insert mode", "i")

  map("[d", vim.diagnostic.goto_next, "Next [D]iagnostic")
  map("]d", vim.diagnostic.goto_prev, "Previous [D]iagnostic")
  map("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, "Previous [E]rror")
  map("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, "Next [E]rror")

  map("<leader>cd", vim.diagnostic.open_float, "Diagnostic in float window")
  map("<leader>cq", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

  map("<leader>rs", ":LspRestart<CR>", "Restart LSP server")

  if client.supports_method("textDocument/formatting") then
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   group = vim.api.nvim_create_augroup('LspFormatGroup', {}),
    --   buffer = buffer,
    --   callback = function()
    --     vim.lsp.buf.format({ bufnr = buffer, id = client.id })
    --     -- HACK: diagnostic is disabled after formatting so we need to enable it again.
    --     vim.diagnostic.enable(true)
    --   end,
    -- })
  end

  -- if client.supports_method('textDocument/documentHighlight') and client.name ~= "copilot" then
  --   print("Activating LspDetach")
  --   print(client.name)
  --
  --   local lsp_highlight_group = vim.api.nvim_create_augroup('LspDocumentHighlight', {})
  --
  --   vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  --     group = lsp_highlight_group,
  --     buffer = buffer,
  --     callback = vim.lsp.buf.document_highlight,
  --   })
  --
  --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --     group = lsp_highlight_group,
  --     buffer = buffer,
  --     callback = vim.lsp.buf.clear_references,
  --   })
  --
  --   vim.api.nvim_create_autocmd('LspDetach', {
  --     group = vim.api.nvim_create_augroup('LspDetachGroup', { clear = true }),
  --     callback = function(event)
  --       print('DETACHING')
  --       vim.api.nvim_clear_autocmds { group = 'LspDocumentHighlight', buffer = event.buf }
  --       vim.lsp.buf.clear_references()
  --     end,
  --   })
  -- end

  if client.supports_method("textDocument/inlayHint") then
    map("<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
    end, "[H]ints")
  end
end

function M.configure_diagnostic()
  M._set_diagnostic_signs()

  vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    virtual_text = {
      source = "if_many",
      prefix = require("stepit.icons").sign.none,
    },
  })
end

function M._set_diagnostic_signs()
  local icons = require("stepit.icons")
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

return M
