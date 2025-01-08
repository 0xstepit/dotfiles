return {
  "hrsh7th/nvim-cmp",
  name = "Completion",
  event = "InsertEnter",
  dependencies = {
    -- Sources
    "hrsh7th/cmp-buffer", --text in current buffer
    "hrsh7th/cmp-path", -- file system paths
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    -- "hrsh7th/cmp-nvim-lsp-signature-help",

    -- Snippets
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",

    "windwp/nvim-autopairs",
  },

  config = function()
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
      vim.api.nvim_err_writeln("CMP module not found or failed to load")
      return
    end

    local lspkind = require("lspkind")
    local luasnip = require("luasnip")

    -- Add parenthesis after completion of method or function.
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    require("luasnip.loaders.from_vscode").lazy_load()
    -- Load custom plugins in snippets folder
    require("luasnip.loaders.from_lua").load({ paths = { "./snippets" } })

    local sources = {
      { name = "luasnip", max_item_count = 3 },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer", max_item_count = 1 },
      { name = "path", max_item_count = 3 },
      -- { name = "nvim_lsp_signature_help" },
    }

    cmp.setup({
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
        fields = { "abbr", "kind", "menu" },
        expandable_indicator = true, -- use ~ after snippets to expand
        format = lspkind.cmp_format({
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
            -- nvim_lsp_signature_help = "[SIG]",
          },
        }),
      },
      sources = cmp.config.sources(sources),
      mapping = {
        -- Scroll documentations
        ["<C-b>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),

        -- Confirm selection
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-q>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm({ select = false }) -- Confirm only if something is explicitly selected
          else
            fallback() -- Insert a new line
          end
        end, { "i", "s" }),

        -- Multipurpose mappings
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then -- jump to previous position is snippet
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "c", "s" }),

        -- ["<C>-Tab>"] = cmp.mapping(function(fallback)
        --   local col = vim.fn.col "." - 1
        --   if cmp.visible() then
        --     if #cmp.get_entries() == 1 then -- if only one entry, confirm it
        --       cmp.confirm { select = true }
        --     else
        --       cmp.select_next_item()
        --     end
        --   elseif col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
        --     fallback()
        --   else
        --     cmp.complete()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item(cmp_select)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      ---@diagnostic disable-next-line: missing-fields
      performance = {
        max_view_entries = 20,
      },
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
