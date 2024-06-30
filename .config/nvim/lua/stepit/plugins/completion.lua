return {
  "hrsh7th/nvim-cmp",
  name = "Completion",
  event = "InsertEnter",
  dependencies = {
    -- Sources
    "hrsh7th/cmp-buffer", --text in current buffer
    "hrsh7th/cmp-path", -- file system paths
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",

    "windwp/nvim-autopairs",
  },
  config = function()
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
      vim.api.nvim_err_writeln "CMP module not found or failed to load"
      return
    end

    local lspkind = require "lspkind"
    local luasnip = require "luasnip"

    -- Add parenthesis after completion of method or function.
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    require("luasnip.loaders.from_vscode").lazy_load()

    -- https://github.com/mrcjkb/nvim/blob/master/nvim/plugin/completion.lua
    local function has_words_before()
      local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    local sources = {
      { name = "luasnip", max_item_count = 5 },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer", max_item_count = 5 },
      { name = "path", max_item_count = 5 },
      { name = "nvim_lsp_signature_help" },
      -- { name = "crates" },
    }

    -- when moving across possible autocompletions they are not
    -- inserted in the code until selected.
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup {

      -- use LuaSnip to expand the snippets in the editor.
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        expandable_indicator = true, -- use ~ after snippets to expand
        format = lspkind.cmp_format {
          mode = "text",
          with_text = true,
          maxwidth = 50,
          ellipsis_char = "...",
          menu = {
            luasnip = "[LSNIP]",
            nvim_lsp = "[NLSP]",
            nvim_lua = "[NLUA]",
            buffer = "[BUF]",
            path = "[PATH]",
            nvim_lsp_signature_help = "[SIG]",
          },
        },
      },
      mapping = {
        -- `i` = insert mode, `c` = command mode, `s` = select mode
        -- fallback: it is used just because suggested by the doc.

        -- Scroll documentations
        ["<C-b>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),

        -- Simple movement in completion
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

        -- Confirm selection
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-q>"] = cmp.mapping.close(),

        -- Multipurpose mappings
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col "." - 1

          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm { select = true }
            else
              cmp.select_next_item()
            end
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
            fallback()
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(cmp_select)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = cmp.config.sources(sources),
    }
  end,
}
