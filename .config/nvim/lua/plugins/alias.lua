return {
  "Konfekt/vim-alias",
  event = "VeryLazy",
  config = function()
    vim.cmd([[
    :Alias            w!!  write\ !sudo\ tee\ >\ /dev/null\ %
    :Alias            k   help\ <C-r><C-w>
    :Alias            l   Lazy<cr>
    :Alias            m   messages<cr>
    :Alias            ft  FzfLua\ filetypes<cr>
    :Alias -range     x   s/\(.*\)/X\ \1\ X/g
    :Alias            g   vertical\ Git<cr><c-w>r
    :Alias            gr  Gread<CR>
    :Alias            gw  Gwrite<CR>
    :Alias            gb  Git\ blame<CR>
    :Alias            gc  Git\ commit<CR>
    :Alias            gd  Git\ diff<CR>
    :Alias            gv  Gvdiffsplit!<CR>
    :Alias            gp  AsyncTask\ git-push<CR>
    :Alias            gf  AsyncTask\ git-pull<CR>
    :Alias            glb  Git\ log\ --stat\ %<CR>
    :Alias            glp  Git\ log\ --stat\ -n\ 100<CR>

    ":Alias -range        Partedit\ -opener\ vnew\ -filetype\ vimpe\ -prefix\ '>'<CR>
    ":Aliases

  ]])
  end,
}
