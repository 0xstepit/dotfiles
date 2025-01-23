return {
  {
    "0xstepit/flow.nvim",
    enabled = true,
    branch = "stepit/blink",
    dev = true,
    lazy = false,
    priority = 1000,
    -- tag = "v1.0.0",
    opts = {
      theme = {
        style = "dark",
        contrast = "default",
        transparent = true,
      },
      colors = {
        mode = "default",
        fluo = "pink",
        custom = {
          -- saturation = "80",
          -- light = "",
        },
      },
      ui = {
        borders = "inverse",
        aggressive_spell = false,
      },
    },
    config = function(_, opts)
      require("flow").setup(opts)
      vim.cmd("colorscheme flow")
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "normal", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
      },
    },
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
