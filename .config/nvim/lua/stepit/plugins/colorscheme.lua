return {
  "0xstepit/berlin-night.nvim",
  dev = true,
  -- name = "Berlin Night",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("berlinnight").setup {
      -- style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      -- light_style = "day", -- The theme is used when the background is set to light
      transparent = true,
      berlinnight_dark_float = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    }
    vim.cmd "colorscheme berlinnight"
    -- -- Override colorscheme colors
    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#293b3d" })
    -- vim.api.nvim_set_hl(0, "Cursor", { bg = "#fd3f92", fg = "#1e1e1e" })
    -- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  end,
}
