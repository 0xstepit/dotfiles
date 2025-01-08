local active_lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)

  if next(clients) == nil then
    return require("stepit.icons").sign.empty
  end

  local clients_ = {}
  for _, client in pairs(clients) do
    table.insert(clients_, client.name)
  end
  return table.concat(clients_, ", ")
end

return {
  "nvim-lualine/lualine.nvim",
  name = "Lualine",
  enabled = true,
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "│",
      section_separators = "",
      -- Lualine bar only under focused pane.
      globalstatus = true,
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
      lualine_b = {
        { "branch", icon = "" },
        { "diff", symbols = { added = "", modified = "", removed = "" } },
      },
      -- lualine_c = { "diagnostics" },
      lualine_c = {
        -- {
        --   'filename',
        --   file_status = true,
        --   newfile_status = true,
        --   path = 1,
        -- },
      },
      lualine_x = {
        "encoding",
        "filetype",
        { "diagnostics", symbols = { error = "", warn = "", info = "", hint = "" } },
      },
      lualine_y = { "progress", "filesize", "searchcount" },
      lualine_z = { active_lsp_clients },
      -- lualine_z = { { clients_lsp, separator = { right = "" }, left_padding = 5 } },
    },
    -- Displayed at the top.
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
