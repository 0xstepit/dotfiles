return {
  "0xstepit/flow.nvim",
  dev = true,
  lazy = false,
  -- tag = "v1.0.0",
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
      -- TODO: update to just "theme" and accept a string.
      dark_theme = dark_theme,
      transparent = transparent,
      high_contrast = true,
      fluo_color = "pink",
      mode = "base",
      aggressive_spell = false,
    }
    vim.cmd "colorscheme flow"
  end,
}
