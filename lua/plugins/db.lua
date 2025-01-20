return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_env_variable_url = "DATABASE_URL"
    vim.g.db_ui_env_variable_name = "DATABASE_NAME"
    vim.g.db_ui_show_notifications = 0
    vim.g.db_ui_save_location = "~/.local/share/db_ui"

    vim.g.db_ui_win_position = "right"
  end,
}
