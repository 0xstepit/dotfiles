return {
  "mbbill/undotree",
  event = "VeryLazy",
  init = function()
    vim.opt.undodir = os.getenv "XDG_CACHE_HOME" .. "/nvim/.undodir"
    vim.g.float_diff = true
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
  keys = {
    {"<leader>u", vim.cmd.UndotreeToggle, "n", { desc = "[U]ndotree toggle" }},
  },
}
