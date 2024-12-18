return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  name = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "folke/todo-comments.nvim",
  },
  config = function()
    -- we need to configure both options and keymaps inside config because:
    -- - options are configured using telescope actions
    -- - keymaps are configured using telescope builtin

    local telescope = require "telescope"
    local actions = require "telescope.actions"
    telescope.load_extension "fzf"

    telescope.setup {
      defaults = {
        layout_strategy = "vertical",
        path_display = { "full" },
        fuzzy = true,
        mappings = {
          i = {
            -- Movements
            ["<C-k>"] = actions.move_selection_previous, -- move up in Results
            ["<C-j>"] = actions.move_selection_next, -- move down in Results
            -- Actions
            ["<C-l>"] = actions.select_default,
            ["<C-y>"] = actions.select_default,
            ["<C-c>"] = actions.close, -- close window
            -- ["<C-c>"] = actions.delete_buffer, -- close buffer
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
      pickers = {
        find_files = {
          -- theme = "dropdown", -- for some reason this is not working
          show_line = true,
          previewer = false,
          disable_devicons = false,
        },
        live_grep = {
          layout_config = {
            width = 0.90,
          },
          -- theme = "dropdown",
          show_line = false,
          disable_devicons = true,
        },
        oldfiles = {
          -- theme = "dropdown",
          previewer = false,
          disable_devicons = true,
          only_cwd = true, -- restrict displayed files to current dir
        },
        lsp_references = {
          layout_config = {
            width = 0.90,
          },
          -- theme = "dropdown",
          preview = true,
          show_line = false,
          disable_devicons = true,
        },
        lsp_implementations = {
          layout_config = {
            width = 0.90,
          },
          -- theme = "dropdown",
          show_line = false,
          disable_devicons = true,
        },
      },
    }

    local builtin = require "telescope.builtin"

    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files in cwd" })
    vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find git files" })
    vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find old files" })
    vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find lsp references" })
    vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope highlights<cr>", { desc = "Find highlight group" })
    vim.keymap.set(
      "n",
      "<leader>cd",
      ":cd %:p:h<CR>:pwd<CR>",
      { desc = "Change current directory (cwd) for Telescope" }
    )
  end,
}
