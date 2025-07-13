return {
  {
    "0xstepit/flow.nvim",
    enabled = true,
    branch = "main",
    dev = true,
    lazy = false,
    priority = 1000,
    -- tag = "v1.0.0",
    opts = {
      theme = {
        style = os.getenv("COLORSCHEME") or "dark",
        contrast = "default",
        transparent = false,
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
    "0xstepit/noble.nvim",
    enabled = false,
    branch = "main",
    dev = true,
    lazy = false,
    priority = 1000,
    -- tag = "v1.0.0",
    opts = {
      colors = {
        background = "grey",
      },
    },
    config = function(_, opts)
      require("noble").setup(opts)
      vim.cmd("colorscheme noble")
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
