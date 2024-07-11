vim.g.asyncrun_exit = "echo 'Success'"
vim.g.asyncrun_open =  20

vim.cmd([[

map <C-J> <Plug>(edgemotion-j)
map <C-K> <Plug>(edgemotion-k)

let g:asterisk#keeppos = 1
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

highlight! link SignatureMarkText WarningMsg

command! CopyFullPath let @+ = expand('%:p') | echo "Full path copied to clipboard"
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

autocmd BufRead,BufWritePre *.blade.php setlocal filetype=php
 augroup vimrc
   autocmd!
   autocmd BufWinEnter,Syntax * syn sync minlines=200 maxlines=200
 augroup END

 cnoremap <expr> / (mode() =~# "[vV\<C-v>]" && getcmdtype() =~ '[/?]' && getcmdline() == '') ? "\<C-c>\<Esc>/\\%V" : '/'
" /<BS>: Inverse search (line NOT containing pattern).
"cnoremap <expr> <BS> (getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'
" Hit space to match multiline whitespace.
"cnoremap <expr> <Space> getcmdtype() =~ '[/?]' ? '\_s\+' : ' '
" //: "Search within visual selection".

" niceblock
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>1o$A':'A')

" Insert formatted datetime (from @tpope vimrc)
inoremap <silent> <C-X><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>
" Print unix time at cursor as human-readable datetime. 1677604904 => '2023-02-28 09:21:45'
"nnoremap gA :echo strftime('%Y-%m-%d %H:%M:%S', '<c-r><c-w>')<cr>
" Repeat last command for each line of a visual selection.
xnoremap . :normal .<CR>
" Repeat the last edit on the next [count] matches.
"nnoremap <silent> gn :normal n.<CR>

augroup vimrc_autocmd
  autocmd!
  " Defaults for text-like buffers.
  autocmd VimEnter,BufNew * autocmd InsertEnter <buffer=abuf> ++once if &filetype ==# '' | exe 'runtime! after/ftplugin/text.vim' | endif
augroup END
]])

