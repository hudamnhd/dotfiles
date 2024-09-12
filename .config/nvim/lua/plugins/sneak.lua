return {
  "justinmk/vim-sneak",
  event = { "BufReadPost" },
  config = function()
    vim.cmd([[
        "map t <Plug>Sneak_s
        "map T <Plug>Sneak_S
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
      ]])
  end,
}
