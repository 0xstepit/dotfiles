-- Vim global variables
local g = vim.g
-- Vim options
local opt = vim.opt

-- Nettw configuration
g.netrw_liststyle = 4
g.netrw_browse_split = 0
g.netrw_localcopydircmd = "cp -r"
g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"
-- vim.g.netrw_banner = 0 -- remove banner

opt.clipboard:append("unnamedplus") -- Copy/paste to/from system clipboard
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
opt.completeopt = "menu,menuone,preview,noinsert,noselect" -- Autocomplete options

-- Visual
opt.termguicolors = true -- enables 24-bit RGB
opt.cursorline = true -- display currentline with different color
opt.signcolumn = "yes" -- display column on left or line number
opt.showmatch = true -- highlight matching parenthesis
-- opt.colorcolumn = "100"

-- Line numbers
opt.number = true -- show line number
opt.relativenumber = true --numbers relative to current line

-- Panes plitting
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horizontal split to the bottom

-- In-file search
opt.ignorecase = true -- ignore case letters when search
opt.smartcase = true -- ignore ignorecase when search has uppercase characters
opt.incsearch = true -- highlight while writing in search

-- Tabs and indentations
opt.expandtab = true -- use spaces instead of tabs
opt.tabstop = 4 -- width of a tab character when saving
opt.softtabstop = 4
opt.shiftwidth = 4 -- blanks inserted in automatic indentation. 0 fall back to tabstop
opt.smartindent = true -- autoindent new lines

-- Scrolling
opt.scrolloff = 10 -- never less than 10 lines at bottom and top
opt.sidescrolloff = 5 -- never less than 5 characters when scrolling horizontally

-- Git
vim.g.blamer_enabled = true
vim.g.blamer_show_in_visual_modes = false

-- spelling check
opt.spelllang = "en_us"
opt.spell = true

opt.list = true
opt.listchars = { space = "·", trail = "·", tab = "│ " }

-- Allow the cursor to move where no character is present in visual block mode.
opt.virtualedit = "block"
-- opt.virtualedit = "all"

-- Folding
opt.foldcolumn = "1"
opt.foldmethod = "indent"
opt.foldenable = false

-- Misc
opt.isfname:append("@-@")
opt.mouse = "a" -- Enable mouse support
-- opt.updatetime = 50
opt.inccommand = "split" -- create a split below with affected text during change
opt.wrap = false -- stop wrapping words in new line
opt.swapfile = false -- stop creating swap files
g.icons_enabled = true

opt.conceallevel = 1
