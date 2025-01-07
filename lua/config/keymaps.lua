-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ba", function()
  vim.cmd("bufdo bd!")
end, { desc = "Close All Buffers" })

-- Center horizontally: scroll the current line to the center horizontally
vim.keymap.set("n", "zh", "zH", { desc = "Scroll right to center horizontally" })
vim.keymap.set("n", "zl", "zL", { desc = "Scroll left to center horizontally" })
