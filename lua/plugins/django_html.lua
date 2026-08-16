return {
  -- Авто-закрытие и переименование HTML тегов
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },

  -- Treesitter: htmldjango понимает и обычный HTML, и Django теги
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "html", "htmldjango" })
    end,
  },

  -- html-lsp + emmet для быстрого набора HTML
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html", "htmldjango" },
        },
        emmet_ls = {
          filetypes = { "html", "htmldjango", "css", "scss" },
        },
      },
    },
  },

  -- Установка через Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "html-lsp", "emmet-ls", "djlint" },
    },
  },
}
