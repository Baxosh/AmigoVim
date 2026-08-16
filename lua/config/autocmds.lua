-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Django HTML шаблоны: устанавливаем filetype htmldjango для .html файлов
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.html",
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})

-- dadbod-ui showing table
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout", -- Match the result buffer type
  callback = function()
    -- vim.cmd("vertical resize 60") -- Set preferred width
    vim.cmd("resize 25") -- Set preferred height
  end,
})
