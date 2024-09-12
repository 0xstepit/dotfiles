return {
  "0xstepit/flow.nvim",
  dev = true,
  lazy = false,
  -- tag = "v1.0.0",
  priority = 1000,
  opts = {},
  config = function()
    require("flow").setup {
      dark_theme = true,
      transparent = true,
      high_contrast = false,
      fluo_color = "pink",
      mode = "desaturate",
      aggressive_spell = false,
    }
    vim.cmd "colorscheme flow"
  end,
}
