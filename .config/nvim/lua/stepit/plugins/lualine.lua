return {
  "nvim-lualine/lualine.nvim",
  name = "Lualine",
  enabled = true,
  config = function()
    local clients_lsp = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.buf_get_clients(bufnr)

      if next(clients) == nil then
        return "No LSP"
      end

      local clients_ = {}
      for _, client in pairs(clients) do
        table.insert(clients_, client.name)
      end
      return "LSP: " .. table.concat(clients_, "|")
    end
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "auto",
        -- No separators.
        component_separators = "│",
        section_separators = "",
        -- -- Lualine bar only under focused pane.
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      -- Displayed at the bottom.
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(res)
              return res:sub(1, 1)
            end,
          },
        },
        lualine_b = { "branch" },
        -- lualine_c = { "diagnostics" },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
            symbols = {
              modified = " ●", -- Text to show when the buffer is modified
              readonly = "", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "", -- Text to show for unnamed buffers.
              newfile = "", -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = { "encoding", "progress", "diagnostics" },
        lualine_y = { "filesize", "searchcount" },
        lualine_z = { clients_lsp },
      },
      -- Displayed at the top.
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
