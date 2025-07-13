# Nvim configuration

## Linting

Static analysis of the code is performed using
[`nvim-lint`](./lua/stepit/plugins/nvim-lint.lua). The plugin allows to specify
which linter and config use for each filetype and when to display linting
information. For common languages, like `go`, the configuration defined at the
project root is used. For suggested configuration for linters please refer to
the files contained in the [config/](./config/) folder. For languages for which
usually no configuration is defined, like markdown, a custom configuration is
defined at the root of this Neovim configuration.
