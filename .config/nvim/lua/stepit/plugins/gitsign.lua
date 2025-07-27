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
    -- word_diff = true, different
    signs = signs,
    signs_staged = signs, -- commit info on the left of a line
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 10,
    },
    current_line_blame = true,
    current_line_blame_formatter = blame_format,
    diff_opts = {
      vertical = false,
    },

    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local opts = { noremap = true, buffer = buffer }

      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next [H]unk" })
      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Previous [H]unk" })
      vim.keymap.set({ "n", "v" }, "<leader>ghs", ":Gitsignoooos stage_hunk<CR>", { desc = "[H]unk [S]tage" })
      vim.keymap.set({ "n", "v" }, "<leader>ghr", ":Gigns reset_hunk<CR>", { desc = "[H]unk [R]eset" })
      vim.keymap.set("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
      vim.keymap.set("n", "<leader>ghp", gs.preview_hunk, { desc = "[H]unk [P]review popup" })

      vim.keymap.set("n", "<leader>gbs", gs.stage_buffer, { desc = "[S]tage [B]uffer" })
      vim.keymap.set("n", "<leader>gbr", gs.reset_buffer, { desc = "[R]eset [B]uffer" })

      vim.keymap.set("n", "<leader>gtl", ":Gitsigns toggle_linehl<CR>", { desc = "[T]oggle [L]ine highlight" })
      vim.keymap.set("n", "<leader>gtw", ":Gitsigns toggle_word_diff<CR>", { desc = "[T]toggle [W]ord diff" })
      vim.keymap.set("n", "<leader>gtb", function()
        gs.blame_line({ full = true })
      end, { desc = "[T]oggle [B]lame line" })

      vim.keymap.set("n", "<leader>gdm", function()
        gs.diffthis("main", { vertical = true, split = "belowright" })
      end, { desc = "[D]iff against [M]ain" })
      vim.keymap.set("n", "<leader>gdt", function()
        vim.ui.input({ prompt = "Git ref to diff against: " }, function(input)
          if input then
            gs.diffthis(input, { vertical = true, split = "belowright" })
          end
        end)
      end, { desc = "[D]iff against [T]his" })
    end,
  },
}
