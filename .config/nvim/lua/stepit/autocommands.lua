vim.api.nvim_create_augroup("OilKeyBindings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "OilKeyBindings",
  pattern = "oil",
  callback = function()
    vim.keymap.set("n", "<c-l>", ":<C-U>TmuxNavigateRight<CR>", { remap = true, buffer = true, silent = true })
    vim.keymap.set("n", "<c-h>", ":<C-U>TmuxNavigateLeft<CR>", { remap = true, buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("stepit/close_with_q", { clear = true }),
  desc = "Close with <q>",
  pattern = {
    "TelescopePrompt",
    "git",
    "fugitive",
    "help",
    "man",
    "qf",
  },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf, noremap = true })
  end,
})

-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L53-L63
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("stepit/last_location", { clear = true }),
  desc = "Go to the last location when opening a buffer",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "TelescopePrompt", "oil", "fugitive", "git", "qf", "GV" },
  desc = "Set cursorline to true when entering a window.",
  callback = function()
    vim.wo.cursorline = false
    vim.wo.colorcolumn = ""
    -- vim.wo.spell = false
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    local exc = { "TelescopePrompt", "oil", "fugitive", "git", "gitcommit", "qf", "GV" }
    local valid = true
    for _, e in ipairs(exc) do
      if vim.bo.filetype == e then
        valid = false
      end
    end

    if valid then
      vim.wo.cursorline = true
      vim.wo.colorcolumn = "100"
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  callback = function()
    vim.wo.cursorline = false
  end,
})
