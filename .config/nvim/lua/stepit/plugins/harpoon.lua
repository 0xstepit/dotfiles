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
    vim.keymap.set("n", "<leader>aa", mark.add_file, { desc = "Mark file with Harpoon" })
    vim.keymap.set("n", "<leader>am", ui.toggle_quick_menu, { desc = "Show Harpoon marks" })

    -- Movements
    vim.keymap.set("n", "<leader>an", ui.nav_next, { desc = "Go to next Harpoon mark" })
    vim.keymap.set("n", "<leader>ap", ui.nav_prev, { desc = "Go to previous Harpoon mark" })

    local function create_harpoon_nav_mappings(number_of_mappings)
      for i = 1, number_of_mappings do
        vim.keymap.set("n", "<leader>a" .. i, function()
          ui.nav_file(i)
        end, { desc = "Go to Harpoon mark " .. i })
      end
    end

    -- Create 5 mappings
    create_harpoon_nav_mappings(5)
  end,
}
