-- Remaps below are used only for rust file.

local bufnr = vim.api.nvim_get_current_buf()

local function desc(description)
  return { noremap = true, silent = true, buffer = bufnr, desc = description }
end

vim.keymap.set('n', '<space>gc', function()
  vim.cmd.RustLsp('openCargo')
end, desc("Open Cargo file of current package."))
