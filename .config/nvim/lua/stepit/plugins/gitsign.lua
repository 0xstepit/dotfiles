local icons = require("stepit.utils.icons")

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
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- word_diff = true,
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

      local opts = { noremap = true, buffer = buffer }

      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next [H]unk" })
      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Previous [H]unk" })
      vim.keymap.set({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "[H]unk [S]tage" })
      vim.keymap.set({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "[H]unk [R]eset" })
      vim.keymap.set("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
      vim.keymap.set("n", "<leader>ghp", gs.preview_hunk, { desc = "[H]unk [P]review popup" })

      vim.keymap.set("n", "<leader>gbs", gs.stage_buffer, { desc = "[S]tage [B]uffer" })
      vim.keymap.set("n", "<leader>gbr", gs.reset_buffer, { desc = "[R]eset [B]uffer" })
      vim.keymap.set("n", "<leader>ghl", ":Gitsigns toggle_linehl<CR>", { desc = "[H]ighlight [L]ine" })
      vim.keymap.set("n", "<leader>gbl", function()
        gs.blame_line({ full = true })
      end, { desc = "[B]lame [L]ine" })

      vim.keymap.set("n", "<leader>gdm", function()
        gs.diffthis("main", { vertical = true, split = "belowright" })
      end, { desc = "Diff this main" })
      vim.keymap.set("n", "<leader>gdt", function()
        gs.diffthis("~", { vertical = true, split = "belowright" })
      end, { desc = "Diff this ~" })
    end,
  },
}
