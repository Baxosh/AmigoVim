return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- `themable = true` (дефолт) ставит группы BufferLine* через
        -- `nvim_set_hl(..., { default = true })`, поэтому после `:hi clear`
        -- новой темы они не перезаписываются и табы застревают на цветах
        -- предыдущей темы. С `false` цвета пересчитываются при каждом
        -- переключении light/dark.
        themable = false,
      },
    },
  },
}
