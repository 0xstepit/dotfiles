return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "ray-x/cmp-treesitter",
    "f3fora/cmp-spell",
  },
  enabled = false,
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Select,
        }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "path" },
        { name = "treesitter" },
        { name = "spell" },
      },
    })

    -- vsnip
    local jumpable_n = vim.fn["vsnip#jumpable"](1)
    local jumpable_p = vim.fn["vsnip#jumpable"](-1)
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      return jumpable_n and "<Plug>(vsnip-jump-next)" or "<C-k>"
    end, { expr = true })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      return jumpable_p and "<Plug>(vsnip-jump-prev)" or "<C-j>"
    end, { expr = true })
  end,
}
