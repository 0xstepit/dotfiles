return {
  "0xstepit/flow.nvim",
  -- dev = false,
  lazy = false,
  tag = "v1.0.0",
  priority = 1000,
  opts = {},
  config = function()
    local dark_theme = true
    local transparent = true

    local style = os.getenv "COLORSCHEME"
    if style == "light" then
      dark_theme = false
      transparent = false
      vim.notify("Changed style to light", vim.log.levels.INFO)
    end

    require("flow").setup {
      dark_theme = dark_theme,
      transparent = transparent,
      high_contrast = false,
      fluo_color = "pink",
      mode = "desaturate",
      aggressive_spell = false,
    }
    vim.cmd "colorscheme flow"
  end,
}
