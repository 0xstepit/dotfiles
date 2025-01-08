vim.api.nvim_create_augroup("OilKeyBindings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "OilKeyBindings",
  pattern = "oil",
  callback = function()
    vim.keymap.set("n", "<c-l>", ":<C-U>TmuxNavigateRight<CR>", { remap = true, buffer = true, silent = true })
    vim.keymap.set("n", "<c-h>", ":<C-U>TmuxNavigateLeft<CR>", { remap = true, buffer = true, silent = true })
  end,
})

-- Does not display linter when opening a floating widow.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo.filetype == "markdown" and vim.api.nvim_win_get_config(0).zindex then
      vim.notify("Diasbling diagnostics for buffer " .. buf, vim.log.levels.INFO)
      vim.diagnostic.enable(false, { bufnr = buf }) -- Disable diagnostics for floating windows
    end
  end,
})
