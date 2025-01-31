return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true, -- Enable inline blame
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- Show blame at the end of the line
      delay = 500, -- Delay before showing blame
      ignore_whitespace = false, -- Ignore whitespace changes
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  },
}
