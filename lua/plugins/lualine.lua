return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1,
            -- 0> Only the file name (no directory paths).
            -- 1> Relative path from the current working directory.
            -- 2> Absolute path (full path starting from /).
            -- 3> Shortened absolute path,

            separator = { right = "" },
            shorting_target = 0, -- Disable shortening
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          {
            "branch",
            separator = { left = "" },
            color = { bg = "#414547", fg = "#b5cadb" },
            right_padding = 2,
          },
        },
      },
    },
  },
}
