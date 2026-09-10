-- 1. Define a helper function to set the theme based on the background
local themes = {
  light = "github_light_colorblind",
  dark = "github_dark_colorblind",
}

local themes = {
  light = "catppuccin-latte",
  dark = "catppuccin-latte",
}

-- Guard: тема сама выставляет `background`, что с `nested = true`
-- заново дёрнуло бы этот же OptionSet.
local applying = false

local function apply_theme()
  if applying then
    return
  end
  applying = true
  local ok, err = pcall(vim.cmd.colorscheme, themes[vim.o.background] or themes.dark)
  applying = false
  if not ok then
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
end

-- 2. Watch for background changes (e.g., if you run :set background=dark manually)
-- `nested = true` обязателен: без него `:colorscheme`, вызванный изнутри
-- автокоманды, не порождает событие ColorScheme, и bufferline / lualine
-- остаются с цветами предыдущей темы.
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  nested = true,
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
