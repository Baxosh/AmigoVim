return {
  "petertriho/nvim-scrollbar",
  dependencies = { "lewis6991/gitsigns.nvim" },
  config = function()
    require("scrollbar").setup({
      handle = {
        color = "#44475a",
      },
      handlers = {
        gitsigns = true,
      },
      marks = {
        Search = { color = "#ff5555" },
        Error = { color = "#ff5555" },
        Warn = { color = "#f1fa8c" },
        Info = { color = "#8be9fd" },
        Hint = { color = "#50fa7b" },
        Misc = { color = "#bd93f9" },
      },
    })
  end,
}
