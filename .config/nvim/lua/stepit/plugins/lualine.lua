local icons = require("stepit.utils.icons")

-- Returns LSP active on the active buffer.
local active_lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if next(clients) == nil then
    return require("stepit.icons").sign.empty
  end

  local clients_ = {}
  for _, client in pairs(clients) do
    table.insert(clients_, client.name)
  end
  return table.concat(clients_, ", ")
end

local function cwd()
  local cwd = vim.fn.getcwd()
  local last_part = cwd:match("([^/]+)$")
  return last_part
end

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  opts = {
    options = {
      icons_enabled = false,
      theme = "auto",
      component_separators = icons.line.vertical.thin.central,
      section_separators = "",
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
        { cwd },
        { "diagnostics", symbols = { error = "", warn = "", info = "", hint = "" } },
      },
      lualine_c = {
        { "branch", icon = icons.git.branch },
        { "diff", symbols = { added = "", modified = "", removed = "" } },
        -- NOTE: deprecated in favor of barbecue.
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
      },
      lualine_y = { "progress", "filesize", "searchcount" },
      lualine_z = { active_lsp_clients },
    },
    -- Displayed at the top.
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    --     tabline = {
    --   lualine_a = {'buffers'},
    --   lualine_b = {},
    --   lualine_c = {},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {'tabs'}
    -- },
    -- winbar = {
    --   -- lualine_a = {},
    --   -- lualine_b = {},
    --   -- lualine_c = {'filename'},
    --   -- lualine_x = {},
    --   -- lualine_y = {},
    --   -- lualine_z = {}
    -- },
    -- inactive_winbar = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = {'filename'},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {}
    -- },
    extensions = {},
  },
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
