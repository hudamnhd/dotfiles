vim.g.asyncrun_exit = "echo 'Success'"
vim.g.asyncrun_open = 20
vim.g.yankround_max_history = 50

vim.cmd([[
map <C-J> <Plug>(edgemotion-j)
map <C-K> <Plug>(edgemotion-k)

"command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

autocmd BufRead,BufWritePre *.blade.php setlocal filetype=php

cnoremap <expr> / (mode() =~# "[vV\<C-v>]" && getcmdtype() =~ '[/?]' && getcmdline() == '') ? "\<C-c>\<Esc>/\\%V" : '/'

" niceblock
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>1o$A':'A')

" Insert formatted datetime (from @tpope vimrc)
inoremap <silent> <C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>
" Print unix time at cursor as human-readable datetime. 1677604904 => '2023-02-28 09:21:45'
"nnoremap gA :echo strftime('%Y-%m-%d %H:%M:%S', '<c-r><c-w>')<cr>

augroup vimrc_autocmd
  autocmd!
  " Defaults for text-like buffers.
  autocmd VimEnter,BufNew * autocmd InsertEnter <buffer=abuf> ++once if &filetype ==# '' | exe 'runtime! after/ftplugin/text.vim' | endif
augroup END

]])
