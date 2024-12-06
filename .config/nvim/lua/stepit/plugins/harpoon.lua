-- Description: Allows marking specific files for fast and focused navigation. Files are marked per project.
return {
  "ThePrimeagen/harpoon",
  name = "Harpoon",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local mark = require "harpoon.mark"
    local ui = require "harpoon.ui"

    -- Harp
    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Harpoon file" })
    vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = "Show harpooned files" })

    -- Movements
    vim.keymap.set("n", "<leader>hn", ui.nav_next, { desc = "Go to next harpoooned mark" })
    vim.keymap.set("n", "<leader>hp", ui.nav_prev, { desc = "Go to previous harpooned mark" })

    local function create_harpoon_nav_mappings(number_of_mappings)
      for i = 1, number_of_mappings do
        vim.keymap.set("n", "<leader>h" .. i, function()
          ui.nav_file(i)
        end, { desc = "Go to harpooned mark " .. i })
      end
    end

    -- Create 5 mappings
    create_harpoon_nav_mappings(9)
  end,
}
