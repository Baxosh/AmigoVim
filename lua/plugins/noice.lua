return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "msg_show",
          find = "DB: Query",
        },
        opts = { skip = true },
      },
    },
  },
}
