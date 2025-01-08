return {
  "tpope/vim-fugitive",
  name = "Fugitive",

  config = function()
    vim.g.fugitive_dynamic_colors = 0
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
    -- <leader>gq to quit blame
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "File blame" })
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
  end,
}
