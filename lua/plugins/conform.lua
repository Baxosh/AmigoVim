return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format" }

    -- ruff из .venv проекта (та же версия, что в pre-commit), иначе — из Mason
    local function project_ruff(_, ctx)
      local venv = vim.fs.find(".venv", { upward = true, type = "directory", path = ctx.dirname })[1]
      local ruff = venv and venv .. "/bin/ruff"
      if ruff and vim.fn.executable(ruff) == 1 then
        return ruff
      end
      return "ruff"
    end
    opts.formatters["ruff_fix"] = { command = project_ruff }
    opts.formatters["ruff_format"] = { command = project_ruff }

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
