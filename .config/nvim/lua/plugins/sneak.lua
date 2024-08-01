return {
  "justinmk/vim-sneak",
  event = { "BufReadPost" },
  config = function()
    vim.cmd([[
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_s
        map T <Plug>Sneak_S
      ]])
  end,
}
