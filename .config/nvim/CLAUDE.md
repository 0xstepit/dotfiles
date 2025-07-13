# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a sophisticated Neovim configuration built around a modular architecture using Lazy.nvim as the plugin manager. The configuration is organized under the `lua/stepit/` namespace with clear separation of concerns.

### Core Initialization Flow
1. `init.lua` → `require('stepit')`
2. `lua/stepit/init.lua` loads modules in sequence:
   - `globals.lua` - Leader key setup (Space key)
   - `options.lua` - Vim options and UI settings
   - `keymaps.lua` - Global key mappings
   - `autocommands.lua` - Event handlers
   - `lazy.lua` - Plugin manager initialization

### Plugin Organization
- **Individual Plugin Files**: Each plugin has its own configuration file in `lua/stepit/plugins/`
- **Lazy Loading**: Extensive use of events, filetypes, and commands for performance
- **Local Development**: Support for local plugin development with `dev = true` and `~/Repositories/NvimPlugin/` path

### Key Systems

#### LSP Configuration
- **Centralized LSP**: `lua/stepit/lsp/server_config.lua` and `lua/stepit/lsp/utils.lua`
- **12 Language Servers**: lua_ls, gopls, ts_ls, rust_analyzer, yamlls, bashls, dockerls, html, cssls, jsonls, marksman, solidity_ls
- **Custom LSP Utils**: Floating window styling, diagnostic configuration, unified keymaps

#### Completion System
- **Blink.cmp**: Modern completion engine (replaced nvim-cmp)
- **LuaSnip Integration**: Custom snippets in `snippets/` directory
- **Full LSP Integration**: All language servers provide completion

#### Formatting & Linting
- **Conform.nvim**: Formatting with stylua, prettier, gofmt, rustfmt, etc.
- **nvim-lint**: Linting integration with per-language configuration
- **Auto-formatting**: Configurable per-buffer formatting on save

#### Note Management System
- **Custom Functions**: Located in `lua/stepit/utils/functions.lua`
- **Environment Variables**: Uses `$NOTES`, `$INBOX`, `$RESOURCES` for note organization
- **Structured Notes**: Frontmatter-based note system with metadata

## Common Commands

### Linting
```bash
# Format Lua files with stylua
stylua lua/

# Lint is handled automatically by nvim-lint plugin
# Configuration in lua/stepit/plugins/nvim-lint.lua
```

### Plugin Management
```vim
:Lazy          " Open Lazy plugin manager
:Lazy sync     " Update all plugins
:Lazy clean    " Remove unused plugins
:Lazy profile  " Profile startup time
```

### Development Workflow
```vim
:LspInfo       " Show LSP server status
:LspRestart    " Restart LSP servers
:ConformInfo   " Show formatting information
:Telescope     " Open fuzzy finder
:Oil           " Open file manager
```

## Key Architecture Decisions

### Modern Plugin Ecosystem
- **Blink.cmp** over nvim-cmp for completion performance
- **Flow.nvim** as primary colorscheme (custom development)
- **Avante.nvim** for AI assistance with Claude integration
- **Snacks.nvim** for various UI enhancements

### Performance Optimizations
- **Lazy Loading**: All plugins use specific triggers (events, filetypes, commands)
- **Disabled Plugins**: Removes unused default vim plugins in lazy.lua:104-110
- **Modular Configuration**: Each plugin isolated in separate files

### UI/UX Enhancements
- **Custom Icons**: Comprehensive icon system in `lua/stepit/utils/icons.lua`
- **Floating Windows**: Consistent rounded borders and custom styling
- **Diagnostic Configuration**: Custom signs and virtual text formatting

## File Structure Patterns

### Plugin Configuration Template
```lua
-- lua/stepit/plugins/example.lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- or specific events
  dependencies = { "dependency/name" },
  opts = {
    -- plugin options
  },
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

### Filetype-Specific Configuration
- **Location**: `after/ftplugin/[filetype].lua`
- **Purpose**: Language-specific settings, keymaps, and options
- **Examples**: `after/ftplugin/go.lua`, `after/ftplugin/typescript.lua`

## Development Notes

### Local Plugin Development
- **Path**: `~/Repositories/NvimPlugin/` (configured in lazy.lua:63)
- **Usage**: Set `dev = true` in plugin spec
- **Example**: devnotes.nvim plugin (lazy.lua:33-39)

### Custom Functions
- **Location**: `lua/stepit/utils/functions.lua`
- **Note Management**: Functions for creating, organizing, and navigating notes
- **Integration**: Used with Telescope for enhanced note workflows

### Git Integration
- **Multiple Plugins**: Gitsigns, Fugitive, GitLinker, Git-Conflict
- **Custom Telescope Functions**: Git diff files, branch management
- **Advanced Workflow**: Comprehensive Git operations with custom keymaps

## Formatting Configuration

### Stylua Settings
- **File**: `stylua.toml`
- **Indent**: 2 spaces
- **Quotes**: Auto-prefer double quotes
- **Requires**: Automatic sorting enabled