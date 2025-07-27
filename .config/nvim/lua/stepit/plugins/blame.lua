return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({
        vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", { desc = "[G]it file blame" }),
      })
    end,
  },
}
