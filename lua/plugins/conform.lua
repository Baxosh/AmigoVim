return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "isort", "black" },
      tsx = { "prettier" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      yaml = { "prettier" },
    },
    servers = {
      vtsls = {
        settings = {
          typescript = {
            format = {
              indentSize = 4,
              tabSize = 4,
              convertTabsToSpaces = true,
              semicolons = "insert",
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
            },
          },
          javascript = {
            format = {
              indentSize = 4,
              tabSize = 4,
              convertTabsToSpaces = true,
            },
          },
        },
      },
    },
  },
}
