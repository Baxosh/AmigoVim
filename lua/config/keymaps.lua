-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move buffer tab left
vim.keymap.set("n", "<leader>bh", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Buffer Left" })
-- Move buffer tab right
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Buffer Right" })
