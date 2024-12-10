-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fu", ":Telescope oldfiles<CR>", { desc = "Find Recently Used Files" })
vim.keymap.set("n", "<leader>fh", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find Hidden Files" })
