return {
  "Konfekt/vim-alias",
  event = "VeryLazy",
  config = function()
    vim.cmd([[
    :Alias            w!!  write\ !sudo\ tee\ >\ /dev/null\ %
    :Alias            k   help\ <C-r><C-w>
    :Alias            w   w<cr>
    :Alias            wq  wq<cr>
    :Alias            l   Lazy<cr>
    :Alias            m   messages<cr>
    :Alias            ft  FzfLua\ filetypes<cr>
    :Alias -range     x   s/\(.*\)/X\ \1\ X/g
    :Alias            gp  AsyncTask\ git-push<CR>
    :Alias            gf  AsyncTask\ git-pull<CR>
    :Alias            s  lua\ Snacks.picker.smart()<CR>

    ":Alias -range        Partedit\ -opener\ vnew\ -filetype\ vimpe\ -prefix\ '>'<CR>
    ":Aliases

  ]])
  end,
}
