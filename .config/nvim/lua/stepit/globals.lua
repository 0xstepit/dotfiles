local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

----------------------------------------
-- Variables used by plugins and keymaps.
----------------------------------------

vim.g.projects_dir = vim.env.HOME .. "/Repositories"

-- Referece branch used for diffs.
g.ref_branch = "main"
-- Flag to activate or deactivate inlay hint.
g.inlay_hints = false

g.update_date = true

g.autoformat = true
