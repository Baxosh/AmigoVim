-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout", -- Match the result buffer type
  callback = function()
    vim.cmd("vertical resize 80") -- Set preferred width
    vim.cmd("resize 30") -- Set preferred height
  end,
})
