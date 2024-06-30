-- Description: visualize git signs for the current file and allows you to easily
-- use git from nvim.
-- Def: a hunk is a single block of changes.
return {
  "lewis6991/gitsigns.nvim",
  name = "Gitsigns",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "│" },
      topdelete = { text = "‾" },
      changedelete = { text = "│" },
      untracked = { text = "┆" },
    },
    -- commit info on the right of a line
    current_line_blame = true,
    current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> - <summary>",

    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local opts = { noremap = true, buffer = buffer }

      -- Keymaps
      opts.desc = "Next hunk"
      vim.keymap.set("n", "]h", gs.next_hunk, opts)
      opts.desc = "Previous hunk"
      vim.keymap.set("n", "[h", gs.prev_hunk, opts)
      opts.desc = "Stage hunk"
      vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
      opts.desc = "Undo stage hunk"
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
      opts.desc = "Reset hunk"
      vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
      opts.desc = "Stage buffer"
      vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts)
      opts.desc = "Reset buffer"
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer, opts)
      opts.desc = "Preview hunk inline"
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, opts)
      opts.desc = "Blame inline"
      vim.keymap.set("n", "<leader>hb", function()
        gs.blame_line { full = true }
      end, opts)
      opts.desc = "Diff this"
      vim.keymap.set("n", "<leader>hd", ":Gitsign diffthis main<CR>", opts)
      opts.desc = "Diff this ~"
      vim.keymap.set("n", "<leader>hD", function()
        gs.diffthis "~"
      end, opts)
      opts.desc = "Gitsign select hunk"
      vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
    end,
  },
}
