return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "isort", "black" }, -- Сначала isort, потом black
    },
  },
}
