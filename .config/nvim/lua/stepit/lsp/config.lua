local M = {}

function M.lua_ls()
  return {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        format = { enable = true },
        hint = {
          enable = true,
          arrayIndex = "Disable",
        },
      },
    },
  }
end

function M.marksman()
  return {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    -- capabilities = lsp_capabilities,
    settings = {
      single_file_support = true,
    },
  }
end

function M.gopls()
  return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    -- capabilities = lsp_capabilities,
    settings = {
      gopls = {
        ["ui.inlayhint.hints"] = {
          compositeLiteralFields = true,
          constantValues = true,
          parameterNames = true,
        },
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
  }
end

function M.buf_ls()
  return {
    default_config = {
      cmd = { "buf", "beta", "lsp", "--timeout=0", "--log-format=text" },
      filetypes = { "proto" },
      root_dir = require("lspconfig.util").root_pattern("buf.yaml", ".git"),
    },
    docs = {
      description = [[
https://github.com/bufbuild/buf

buf beta lsp included in the cli itself

buf beta lsp is a Protobuf language server compatible with Buf modules and workspaces
]],
    },
  }
end

return M
