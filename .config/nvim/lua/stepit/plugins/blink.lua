return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "MeanderingProgrammer/render-markdown.nvim",
    { "L3MON4D3/LuaSnip", version = "v2.*" },
  },
  event = "InsertEnter",
  version = "*",
  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<CR>"] = {
        function(cmp)
          if cmp.snippet_active then
            return cmp.accept()
          end
        end,
        "fallback",
      },
      ["<C-q>"] = { "hide", "fallback" },

      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_next()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_prev()
          end
        end,
        "snippet_backward",
        "fallback",
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      kind_icons = require("stepit.utils.icons").symbol_kinds,
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },

    completion = {
      list = { selection = { preselect = false, auto_insert = true } },

      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "label", "label_description", gap = 3 },
            { "kind_icon", "kind", gap = 1 },
            { "source_name", gap = 3 },
          },
        },
      },
      documentation = {
        window = {
          border = "rounded",
          max_width = math.floor(vim.o.columns * 0.7),
          max_height = math.floor(vim.o.lines * 0.5),
        },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
    signature = { window = { border = "rounded" }, enabled = true },
  },
  opts_extend = { "sources.default" },
}
