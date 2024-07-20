return {
  "0xstepit/flow.nvim",
  dev = true,
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("flow").setup_options {
      transparent = true,
      fluo_color = "pink",
      mode = "normal",
      aggressive_spell = false,
    }
    vim.cmd "colorscheme flow"
  end,
}

-- return {
--   "AlexvZyl/nordic.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {},
--   config = function()
--     require("nordic").load()
--   end,
-- }
