# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written in Lua, using lazy.nvim as the plugin manager. The configuration emphasizes custom implementations over pre-built solutions (custom statusline, winbar, tabline, and notes management system).

## Architecture

### Entry Point and Loading Order

The configuration loads in this specific order (see `lua/stepit/init.lua`):
1. `stepit.globals` - Global utilities and variables
2. `stepit.options` - Vim options and settings
3. `stepit.keymaps` - General keymaps (LSP keymaps are in `stepit.lsp`)
4. `stepit.autocommands` - Autocommands for UI elements and file types
5. `stepit.notes` - Custom note-taking system
6. `stepit.lsp` - LSP configuration and keymaps
7. `stepit.winbar` - Custom winbar implementation
8. `stepit.tabline` - Custom tabline implementation
9. `stepit.statusline` - Custom statusline implementation
10. `stepit.filetype` - Custom filetype detection
11. `lazy.setup()` - Plugins loaded from `lua/stepit/plugins/`

### LSP Architecture

LSP is configured using Neovim's native `vim.lsp.enable()` system (NOT nvim-lspconfig):
- LSP configurations are stored in `/lsp/*.lua` files (e.g., `lsp/lua_ls.lua`, `lsp/gopls.lua`)
- Each file returns a `vim.lsp.Config` table with `cmd`, `filetypes`, `root_markers`, and `settings`
- The main LSP file (`lua/stepit/lsp.lua`) automatically discovers and enables all LSP servers from the `/lsp/` directory
- `on_attach` function sets up buffer-local keymaps and features like document highlighting and inlay hints
- Dynamic capability registration is handled to support LSP servers that advertise capabilities after initial attachment

### Custom Statusline/Winbar/Tabline

All three are custom implementations (NOT using lualine or similar plugins):
- **Statusline** (`lua/stepit/statusline.lua`): Shows mode, git branch, diagnostics, snippet status, file info, and active LSP clients
- **Winbar** (`lua/stepit/winbar.lua`): Displays breadcrumb-style file path with special handling for environment variables (DOTFILES, WORK, REPOS)
- **Tabline** (`lua/stepit/tabline.lua`): Simple custom tab display

All use highlight groups and `vim.o` options directly.

### Notes System

A custom Zettelkasten-style note management system (`lua/stepit/notes.lua`) with these features:
- Notes stored in `$NOTES/main/$INBOX/` directory (uses env vars)
- Each note is a folder containing a markdown file with YAML frontmatter
- Automatic frontmatter generation with author, title, slug, dates, tags, etc.
- Tag selection via fzf-lua with multi-select support
- Auto-updates `modified` field in frontmatter on save for markdown files in `$NOTES`
- Image management: move images to note folder and insert markdown references
- Keymaps: `<leader>mf` (find note), `<leader>mn` (new note), `<leader>mi` (move image)

### Plugin Organization

Plugins are organized as individual files in `lua/stepit/plugins/`:
- Each plugin file returns a lazy.nvim spec table
- The main init loads all plugins via `{ import = "stepit.plugins" }`
- Key plugins:
  - **blink.cmp**: Completion (with LuaSnip integration)
  - **fzf-lua**: Fuzzy finder (preferred over Telescope)
  - **conform.nvim**: Formatting with per-language formatters
  - **nvim-treesitter**: Syntax highlighting and tree-sitter features
  - **gitsigns**: Git integration
  - **mini.files**: File explorer

### Snippet System

LuaSnip is used for snippets with custom snippets in `/snippets/*.lua`:
- Snippets are organized by filetype (e.g., `snippets/go.lua`, `snippets/markdown.lua`)
- Statusline shows "SNIP" indicator when a snippet position is jumpable
- Special autocmd to exit snippets on insert mode end

## Common Development Tasks

### Testing Configuration Changes

Source the current file:
```
<leader><leader>x
```

Or reload Neovim entirely.

### Managing Plugins

Lazy.nvim commands:
```
:Lazy
:Lazy update
:Lazy clean
```

### LSP Development

When adding a new LSP server:
1. Create a new file in `/lsp/server_name.lua`
2. Return a `vim.lsp.Config` table with the required fields
3. Restart Neovim - the server will be auto-discovered and enabled

Example structure:
```lua
---@type vim.lsp.Config
return {
  cmd = { "server-command" },
  filetypes = { "filetype" },
  root_markers = { "marker-file" },
  settings = {
    -- server-specific settings
  },
}
```

### Formatting

Formatting is handled by conform.nvim:
- Auto-format on save (can be toggled per-buffer with `<leader>tf`)
- Formatters defined in `lua/stepit/plugins/conform.lua` by filetype
- Format injected languages (e.g., code blocks in markdown): `<leader>ci`

### Working with Notes

The notes system requires these environment variables:
- `$NOTES`: Root notes directory
- `$INBOX`: Inbox folder name
- `$RESOURCES`: Resources folder name

Create a new note:
```
<leader>mn  " Opens fzf to search/create, Ctrl-N to create from query
```

Find existing note:
```
<leader>mf
```

## Important Patterns

### Highlight Groups

Custom highlight groups are used throughout:
- `StatuslineMode`, `StatuslineGitBranch` for statusline
- `WinBarSpecial`, `WinbarPath`, `WinBarFile` for winbar
- Diagnostic groups are reused from built-in `DiagnosticError`, `DiagnosticWarn`, etc.

### Icon System

Icons are centralized in `lua/stepit/utils/icons.lua` (inferred from imports) and used throughout the config for consistent visual elements.

### Window Management

Custom keymaps for window resizing and navigation:
- `<C-h/j/k/l>`: Navigate windows
- `<C-t/s/c/b>`: Resize windows (height/width)
- `<leader>z`: Toggle centered mode (custom utility)

### Environment Variables

The config uses environment variables for paths:
- `DOTFILES`, `WORK`, `REPOS`: For winbar path abbreviation
- `NOTES`, `INBOX`, `RESOURCES`: For notes system
- `VIMRUNTIME`: For lua_ls workspace library

## Configuration Philosophy

This configuration prefers:
- Custom implementations over heavy plugins (statusline, winbar, notes)
- Native Neovim features over abstractions (LSP, treesitter)
- Lua over Vimscript
- Explicit configuration over magic defaults
- Minimal dependencies where practical
