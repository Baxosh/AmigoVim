-- 1. Define a helper function to set the theme based on the background
local function apply_theme()
  if vim.o.background == "light" then
    vim.cmd.colorscheme("github_light_colorblind")
  else
    vim.cmd.colorscheme("github_dark_colorblind")
  end
end

-- 2. Watch for background changes (e.g., if you run :set background=dark manually)
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = apply_theme,
})

return {
  -- Load the GitHub theme plugin
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },

  -- Load the Gruvbox theme plugin
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent_mode = false },
  },

  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Configure LazyVim to execute our helper function on startup
  {
    "LazyVim/LazyVim",
    -- opts = {
    --   colorscheme = "gruvbox",
    --   -- colorscheme = "github",
    --   -- colorscheme = "solarized-osaka",
    -- },
    opts = {
      colorscheme = function()
        apply_theme()
      end,
    },
  },
}
