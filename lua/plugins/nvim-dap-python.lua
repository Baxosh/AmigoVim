return {
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Test Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Test Class", ft = "python" },
      { "<leader>dPf", function() require('dap-python').debug_file() end, desc = "Debug File", ft = "python" },
      { "<leader>dPs", function() require('dap-python').debug_selection() end, desc = "Debug Selection", ft = "python" },
    },
  },
}
