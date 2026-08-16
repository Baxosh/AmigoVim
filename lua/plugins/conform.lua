return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format" }

    -- djlint форматирует Django шаблоны без поломки {% %} тегов
    opts.formatters_by_ft.htmldjango = { "djlint" }
    opts.formatters_by_ft.html = { "djlint" }
    opts.formatters["djlint"] = {
      args = { "--profile", "django", "--reformat", "-" },
    }

    -- Явно перезаписываем SQL форматтеры, чтобы исключить sqlfluff
    -- (LazyVim sql extra добавляет его через table.insert)
    opts.formatters_by_ft.nginx = { "nginxfmt" }

    opts.formatters_by_ft.sql = { "sqruff" }
    opts.formatters_by_ft.mysql = { "sqruff" }
    opts.formatters_by_ft.plsql = { "sqruff" }
    opts.formatters["sqruff"] = {
      stdin = false,
      args = { "fix", "--config", vim.fn.expand("~/.sqruff"), "$FILENAME" },
    }
    return opts
  end,
}
