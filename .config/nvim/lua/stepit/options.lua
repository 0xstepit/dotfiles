local opt = vim.opt

vim.opt.clipboard = "unnamedplus"

-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
opt.completeopt = "menu,menuone,preview,noinsert,noselect" -- Autocomplete options

-- Visual
opt.termguicolors = true -- enables 24-bit RGB
opt.cursorline = true -- display current line with different color
opt.signcolumn = "yes" -- display column on left of line number
opt.showmatch = true -- highlight matching parenthesis
opt.colorcolumn = "100" -- number of spaces at which the colorcolumn is
opt.virtualedit = "block" -- allow the cursor to move where no character is present in visual block mode.

-- Line numbers
opt.number = true -- show line number
opt.relativenumber = true --numbers relative to current line

-- Panes splitting
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horizontal split to the bottom

-- In-file search
opt.ignorecase = true -- ignore case letters when search
opt.smartcase = true -- ignore ignorecase when search has uppercase characters
opt.incsearch = true -- highlight while writing in search

-- Tabs and indentations
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- size of an indent
opt.tabstop = 4 -- number of spaces a tab counts for (very much needed in go)
opt.smartindent = true -- autoindent new lines

-- Scrolling
opt.scrolloff = 15 -- never less than these lines at bottom and top when scrolling
opt.sidescrolloff = 5 -- never less than these characters when scrolling horizontally

-- Spelling check
opt.spelllang = { "en_us" }
opt.spell = false

-- Save undo history.
vim.o.undofile = true

-- Folding
function FoldStyle()
  local line = vim.fn.getline(vim.v.foldstart)
  return " " .. line .. "..."
end

-- Folding
opt.foldcolumn = "0"
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldtext = "v:lua.FoldStyle()"
opt.foldnestmax = 3
opt.foldlevelstart = 3
opt.foldlevel = 99

-- Misc
opt.isfname:append("@-@")
opt.mouse = "a" -- enable mouse support in all modes
opt.conceallevel = 2 -- conceals disabled
opt.inccommand = "split" -- create a bottom split with affected text during change
opt.textwidth = 100
opt.wrap = false -- stop wrapping words in new line
opt.swapfile = false -- stop creating swap files
opt.updatetime = 250
opt.timeoutlen = 250
-- TODO: this is not working because overwritten by something else.
opt.formatoptions:remove({ "r", "c" })

-- Show trailing whitespaces and tab.
vim.opt.list = true
vim.opt.listchars = { space = " ", trail = "⋅", tab = require("stepit.icons").line.vertical.thin .. " " }

-- vim.opt.fillchars = {
--   horiz = "▔",
--   horizup = "▔",
--   horizdown = "▁",
--   -- vert = C.right_thick,
--   -- vertleft = C.right_thick,
--   -- vertright = C.right_thick,
--   -- verthoriz = C.right_thick,
-- }
