return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    pcall(require("telescope").load_extension, "fzf")

    local icons = require("stepit.utils.icons")

    telescope.setup({
      defaults = {
        prompt_prefix = " " .. icons.symbols.lens .. "   ",
        selection_caret = " " .. icons.arrow.fat .. " ",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.70,
        },
        disable_devicons = true,
        path_display = { "full" },
        fuzzy = true,
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-c>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-c>"] = actions.close,
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
          theme = "dropdown",
          show_line = true,
          previewer = false,
        },
        live_grep = {
          show_line = false,
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
          only_cwd = true,
        },
        lsp_references = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.90,
          },
          preview = true,
          show_line = false,
        },
        lsp_implementations = {
          show_line = false,
        },
      },
    })

    local builtin = require("telescope.builtin")

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    map("<leader>ff", builtin.find_files, "[F]iles in cwd")
    map("<leader>fg", builtin.git_files, "[G]it files")
    map("<leader>fc", builtin.git_commits, "[C]ommits")
    map("<leader>fs", builtin.live_grep, "[S]tring in cwd")
    map("<leader>fw", builtin.grep_string, "[W]ord under cursor in cwd")
    map("<leader>fo", builtin.oldfiles, "[O]ld files")
    map("<leader>fb", builtin.buffers, "Open [B]uffers")
    map("<leader>fh", builtin.highlights, "[H]ighlight groups")

    -- TODO: add custom for todo, fix, ...
  end,
}
