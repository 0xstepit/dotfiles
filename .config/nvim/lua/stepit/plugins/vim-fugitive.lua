return {
  "tpope/vim-fugitive",
  config = function()
    vim.g.fugitive_dynamic_colors = 0
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "[G]it status" })
    vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "[G]it log" })
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "[G]it file blame" })
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "[G]it push" })
  end,
}
