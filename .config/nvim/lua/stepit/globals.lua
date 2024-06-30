local g = vim.g

-- space as leader
g.mapleader = " "

-- Nettw configuration
g.netrw_liststyle = 4
g.netrw_browse_split = 0
g.netrw_localcopydircmd = "cp -r"
g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"

-- Git
g.blamer_enabled = true
g.blamer_show_in_visual_modes = false

g.icons_enabled = true
vim.g.have_nerd_font = true
