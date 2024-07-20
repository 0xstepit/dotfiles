return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("mason-nvim-dap").setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
      },
    }

    vim.keymap.set("n", "<leader>dd", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<leader>de", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
    end, { desc = "Debug: Set Breakpoint" })

    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = " ",
          play = " ",
          step_into = "󱞣",
          step_over = "󰑃",
          step_out = "󰑁",
          step_back = "󱞿",
          run_last = "",
          terminate = "",
          disconnect = "",
        },
      },
    }

    vim.keymap.set("n", "<leader>ds", dapui.toggle, { desc = "Debug: See last session result" })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = " ﳁ", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
    vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped" })

    require("dap-go").setup {
      delve = {
        detached = vim.fn.has "win32" == 0,
      },
    }
  end,
}
