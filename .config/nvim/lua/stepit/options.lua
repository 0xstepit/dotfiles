local opt = vim.opt
local icons = require("stepit.utils.icons")

-- General
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,preview,noinsert"
opt.undofile = true
opt.mouse = "a"
opt.conceallevel = 2
opt.wrap = false
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 250

-- Change guicursor
-- vim.o.guicursor = "i-r:hor20-Cursor"

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"

-- Visual
opt.showmatch = true
opt.virtualedit = "block"
opt.list = true
opt.listchars = {
  space = " ",
  trail = "⋅",
  tab = icons.line.vertical.thin.left .. " ",
}
opt.fillchars = {
  foldclose = icons.chevron.right,
  foldopen = icons.chevron.down,
  foldsep = " ",
}
opt.inccommand = "split"

-- Numbers
opt.number = true
opt.relativenumber = true

-- Windows
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Indentation
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4

opt.smartindent = true

-- Scrolling
opt.scrolloff = 15
opt.sidescrolloff = 10

-- Spelling
opt.spelllang = { "en" }
opt.spell = false

-- Folding
function FoldStyle()
  local line = vim.fn.getline(vim.v.foldstart)
  return " " .. line
end

-- opt.statuscolumn='%s%C  %l%=  '
opt.foldcolumn = "0"
opt.foldenable = true
opt.foldmethod = "indent"
-- opt.foldtext = "v:lua.FoldStyle()"
opt.foldtext = ""
opt.foldlevelstart = 99 -- no fold initially

vim.opt.diffopt:append({
  "internal",
  "algorithm:patience",
  "indent-heuristic",
  "linematch:60", -- Enables intra-line diff highlighting
})
