return {
  "Konfekt/vim-alias",
  event = "VeryLazy",
  config = function()
    vim.cmd([[
    :Alias            w!!  write\ !sudo\ tee\ >\ /dev/null\ %
    :Alias            w   update<cr>
    :Alias            k   help\ <C-r><C-w>
    :Alias            L   Lazy<cr>
    :Alias -range     x   s/\(.*\)/X\ \1\ X/g
    ":Alias -range        Partedit\ -opener\ vnew\ -filetype\ vimpe\ -prefix\ '>'<CR>
    ":Aliases

  ]])
  end,
}
