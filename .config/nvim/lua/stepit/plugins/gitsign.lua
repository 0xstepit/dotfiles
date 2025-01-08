local icons = require("stepit.icons")

local signs = {
  add = { text = icons.line.vertical.single },
  change = { text = icons.line.vertical.single },
  delete = { text = icons.line.vertical.single },
  topdelete = { text = icons.line.horizontal.top },
  changedelete = { text = icons.line.vertical.single },
  untracked = { text = icons.line.vertical.dash },
}

local blame_format = icons.species.person .. " <author>, <author_time:%d-%m-%Y> " .. icons.git.commit .. " <summary>"

return {
  "lewis6991/gitsigns.nvim",
  name = "Gitsigns",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = signs,
    signs_staged = signs, -- commit info on the left of a line
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    current_line_blame = true,
    current_line_blame_formatter = blame_format,

    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local gitlinker = require("gitlinker")

      local opts = { noremap = true, buffer = buffer }

      -- Keymaps
      opts.desc = "Next hunk"
      vim.keymap.set("n", "]h", gs.next_hunk, opts)

      opts.desc = "Previous hunk"
      vim.keymap.set("n", "[h", gs.prev_hunk, opts)

      opts.desc = "Stage hunk"
      vim.keymap.set({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", opts)

      opts.desc = "Undo stage hunk"
      vim.keymap.set("n", "<leader>ghu", gs.undo_stage_hunk, opts)

      opts.desc = "Reset hunk"
      vim.keymap.set({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", opts)

      opts.desc = "Stage buffer"
      vim.keymap.set("n", "<leader>ghS", gs.stage_buffer, opts)

      opts.desc = "Reset buffer"
      vim.keymap.set("n", "<leader>ghR", gs.reset_buffer, opts)

      opts.desc = "Preview hunk inline"
      vim.keymap.set("n", "<leader>ghp", gs.preview_hunk_inline, opts)

      opts.desc = "Blame inline"
      vim.keymap.set("n", "<leader>gbl", function()
        gs.blame_line({ full = true })
      end, opts)

      opts.desc = "Blame inline"
      vim.keymap.set("n", "<leader>gbf", function()
        gs.blame()
      end, opts)

      opts.desc = "Diff this main"
      vim.keymap.set("n", "<leader>gdm", function()
        gs.diffthis("main", { vertical = true, split = "belowright" })
      end, opts)

      opts.desc = "Diff this ~"
      vim.keymap.set("n", "<leader>gdt", function()
        gs.diffthis("~", { vertical = true, split = "belowright" })
      end, opts)

      opts.desc = "Select hunk"
      vim.keymap.set({ "o", "x" }, "gsh", ":<C-U>Gitsigns select_hunk<CR>", opts)

      opts.desc = "Highlight line"
      vim.keymap.set("n", "<leader>ghl", ":Gitsigns toggle_linehl<CR>", opts)
    end,
  },
}
