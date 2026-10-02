-- 1. Define a helper function to set the theme based on the background
-- local themes = {
--   light = "github_light_colorblind",
--   dark = "github_dark_colorblind",
-- }

local themes = {
  light = "github_light",
  dark = "gruvbox",
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

-- Группа с `clear = true`: lazy.nvim перечитывает спеки при изменении файлов,
-- и без неё каждая перезагрузка добавляла ещё одну копию автокоманд.
local group = vim.api.nvim_create_augroup("user_theme_sync", { clear = true })

-- 2. Watch for background changes (e.g., if you run :set background=dark manually)
-- `nested = true` обязателен: без него `:colorscheme`, вызванный изнутри
-- автокоманды, не порождает событие ColorScheme, и bufferline / lualine
-- остаются с цветами предыдущей темы.
vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = "background",
  nested = true,
  callback = apply_theme,
})

-- 3. Свой обработчик ответа терминала на OSC 11. Встроенный (группа `nvim.tty`)
-- Neovim удаляет на VimEnter, если `background` выставил не он сам, а темы
-- (catppuccin, github) делают это в `colors/*.lua`. Без него смена темы в
-- Ghostty/tmux (mode 2031 → повторный запрос OSC 11) до `background` не доходит.
vim.api.nvim_create_autocmd("TermResponse", {
  group = group,
  nested = true,
  callback = function(ev)
    local r, g, b = ev.data.sequence:match("^\027%]11;rgba?:(%x+)/(%x+)/(%x+)")
    if not r then
      return
    end
    local function channel(hex)
      return tonumber(hex, 16) / (16 ^ #hex - 1)
    end
    local luminance = 0.299 * channel(r) + 0.587 * channel(g) + 0.114 * channel(b)
    local bg = luminance < 0.5 and "dark" or "light"
    if vim.o.background ~= bg then
      vim.o.background = bg
    end
  end,
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
    --   -- colorscheme = "gruvbox",
    --   -- colorscheme = "github",
    --   -- colorscheme = "solarized-osaka",
    --   -- colorscheme = "catppuccin",
    -- },
    opts = {
      colorscheme = function()
        apply_theme()
      end,
    },
  },
}
