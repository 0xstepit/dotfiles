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
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 0, -- Highest priority
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = -10, -- Lower priority than LSP
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = -20, -- Even lower priority
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
          },
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = -30, -- Lowest priority
          opts = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      },
    },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
        max_items = 20,
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      trigger = {
        prefetch_on_insert = true,
        show_in_snippet = true,
      },
      menu = {
        border = "rounded",
        max_height = 12,
        scrolloff = 2,
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind", "source_name", gap = 1 },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
      },
      documentation = {
        window = {
          border = "rounded",
          max_width = math.floor(vim.o.columns * 0.4),
          max_height = math.floor(vim.o.lines * 0.3),
        },
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
      },
    },
    signature = { window = { border = "rounded" }, enabled = true },
  },
  opts_extend = { "sources.default" },
}
