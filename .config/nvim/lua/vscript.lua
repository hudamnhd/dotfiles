vim.g.asyncrun_exit = "echo 'Success'"
vim.g.asyncrun_open = 20
vim.g.SignaturePrioritizeMarks = 0
vim.g.SignatureEnabledAtStartup = 1
vim.g.yankround_max_history = 50
-- vim.g.ctrlp_match_window = "bottom,order:btt,min:1,max:15,results:15"
-- vim.g.ctrlp_user_command = 'fd . --type f'

vim.g.SignatureMap = {
  Leader = "m",
  PlaceNextMark = "",
  ToggleMarkAtLine = "",
  PurgeMarksAtLine = "",
  DeleteMark = "",
  PurgeMarks = "",
  PurgeMarkers = "",
  GotoNextLineAlpha = "",
  GotoPrevLineAlpha = "",
  GotoNextSpotAlpha = "",
  GotoPrevSpotAlpha = "",
  GotoNextLineByPos = "",
  GotoPrevLineByPos = "",
  GotoNextSpotByPos = "",
  GotoPrevSpotByPos = "",
  GotoNextMarker = "",
  GotoPrevMarker = "",
  GotoNextMarkerAny = "",
  GotoPrevMarkerAny = "",
  ListBufferMarks = "",
  ListBufferMarkers = "",
}

vim.cmd([[

let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

map <C-J> <Plug>(edgemotion-j)
map <C-K> <Plug>(edgemotion-k)

"let g:asterisk#keeppos = 1

"map *  <Plug>(asterisk-z*)
"map #  <Plug>(asterisk-z#)
"map g* <Plug>(asterisk-gz*)
"map g# <Plug>(asterisk-gz#)

highlight! link SignatureMarkText WarningMsg

"command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

autocmd BufRead,BufWritePre *.blade.php setlocal filetype=php

cnoremap <expr> / (mode() =~# "[vV\<C-v>]" && getcmdtype() =~ '[/?]' && getcmdline() == '') ? "\<C-c>\<Esc>/\\%V" : '/'
 "augroup vimrc
 "  autocmd!
 "  autocmd BufWinEnter,Syntax * syn sync minlines=200 maxlines=200
 "augroup END

" /<BS>: Inverse search (line NOT containing pattern).
"cnoremap <expr> <BS> (getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'
" Hit space to match multiline whitespace.
"cnoremap <expr> <Space> getcmdtype() =~ '[/?]' ? '\_s\+' : ' '
" //: "Search within visual selection".

" niceblock
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>1o$A':'A')

" Insert formatted datetime (from @tpope vimrc)
inoremap <silent> <C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>
" Print unix time at cursor as human-readable datetime. 1677604904 => '2023-02-28 09:21:45'
"nnoremap gA :echo strftime('%Y-%m-%d %H:%M:%S', '<c-r><c-w>')<cr>
" Repeat last command for each line of a visual selection.
xnoremap . :normal .<CR>
" Repeat the last edit on the next [count] matches.
nnoremap <silent> gn :normal n.<CR>

augroup vimrc_autocmd
  autocmd!
  " Defaults for text-like buffers.
  autocmd VimEnter,BufNew * autocmd InsertEnter <buffer=abuf> ++once if &filetype ==# '' | exe 'runtime! after/ftplugin/text.vim' | endif
augroup END

set showtabline=1  " 1 to show tabline only when more than one tab is present
set tabline=%!MyTabLine()  " custom tab pages line
function! MyTabLine() " acclamation to avoid conflict
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= '%' . (t + 1) . 'T'
        let s .= ' '
        " set page number string
        let s .= t + 1 . ' '
        " get buffer names and statuses
        let n = ''      " temp string for buffer names while we loop and check buftype
        let m = 0       " &modified counter
        let bc = len(tabpagebuflist(t + 1))     " counter to avoid last ' '
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype"  ) == 'help'
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//'  )
            elseif getbufvar( b, "&buftype"  ) == 'quickfix'
                let n .= '[Q]'
            else
                let n .= pathshorten(bufname(b))
            endif
            " check and ++ tab's &modified count
            if getbufvar( b, "&modified"  )
                let m += 1
            endif
            " no final ' ' added...formatting looks better done later
            if bc > 1
                let n .= ' '
            endif
            let bc -= 1
        endfor
        " add modified label [n+] where n pages in tab are modified
        if m > 0
            let s .= '[' . m . '+]'
        endif
        " select the highlighting for the buffer names
        " my default highlighting only underlines the active tab
        " buffer names.
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " add buffer names
        if n == ''
            let s.= '[New]'
        else
            let s .= n
        endif
        " switch to no underlining and add final space to buffer list
        let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLineFill#%999Xclose'
    endif
    return s
endfunction"

]])
