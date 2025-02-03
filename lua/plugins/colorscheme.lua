return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- darcula
  -- {
  --   "doums/darcula",
  --   config = function()
  --     vim.cmd("colorscheme darcula")
  --   end,
  -- },
}
