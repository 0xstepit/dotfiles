-- Description: allows to have multiple history dimensions
-- for the file we are working on. The undodir is used to keep the
-- history file changes also after quitting vim.
return {
  "mbbill/undotree",
  name = "Undotree",
  config = function()
    -- Folder where history for undotree is stored.
    vim.opt.undodir = os.getenv "XDG_CACHE_HOME" .. "/nvim/.undodir"
    vim.opt.undofile = true
    vim.g.float_diff = true
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
  end,
}
