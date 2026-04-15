return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format" }

    -- Явно перезаписываем SQL форматтеры, чтобы исключить sqlfluff
    -- (LazyVim sql extra добавляет его через table.insert)
    opts.formatters_by_ft.sql = { "sqruff" }
    opts.formatters_by_ft.mysql = { "sqruff" }
    opts.formatters_by_ft.plsql = { "sqruff" }
    return opts
  end,
}
