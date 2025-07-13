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

M.typescript = {
  settings = {
    -- Complete LSP features
    complete_function_calls = true,
    include_completions_with_insert_text = true,

    -- Inlay hints
    inlay_hints = {
      parameter_hints = {
        enabled = true,
        show_parameter_names = true,
      },
      type_hints = {
        enabled = true,
        show_variable_type_hints = true,
        show_function_parameter_type_hints = true,
        show_return_type_hints = true,
      },
    },

    -- Code style and formatting
    code_lens = true,
    format_on_save = true,

    -- Additional features
    expose_as_code_action = "all",
    filter_out_diagnostics_by_code = {},
    filter_out_diagnostics_by_severity = {},

    -- JavaScript support
    jsx_close_tag = {
      enable = true,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
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
        deprecated = true,
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

M.html = {
  filetypes = { "html" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
  settings = {},
  single_file_support = true,
}

M.cssls = {
  filetypes = { "css", "scss", "less" },
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
  single_file_support = true,
}

M.bashls = {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)",
    },
  },
  single_file_support = true,
}

M.dockerls = {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_dir = vim.fs.dirname(vim.fs.find("Dockerfile", { path = "", upward = true })[1]),
  settings = {},
  single_file_support = true,
}

return M
