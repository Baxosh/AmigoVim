return {
  -- github colorscheme
  { "projekt0n/github-nvim-theme", name = "github-theme" },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- darcula
  { "doums/darcula" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
    },
  },
}
