local M = {}

M.lua_ls = {
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

M.marksman = {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  settings = {
    single_file_support = true,
  },
}

M.solidity_ls_nomicfoundation = {
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetypes = { "solidity" },
  root_dir = vim.fs.dirname(vim.fs.find(".git", { path = "", upward = true })[1]),
  single_file_support = true,
}

M.solidity_ls = {
  settings = {
    solidity = {
      enabledAsYouTypeCompilationErrorCheck = true,
      validationDelay = 1500,
    },
  },
}

M.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      gofumpt = true,
      buildFlags = { "-tags=build" },
      -- directoryFilters = { "-utils" },
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
      -- completeUnimported = true,
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        assign = true,
        shadow = false,
      },
      staticcheck = true,
    },
  },
}

M.buf_ls = {
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

return M
