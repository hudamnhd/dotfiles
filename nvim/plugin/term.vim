" command! -bar -count=12 Dresize
"   \ lua require 'utils.m.drawer.win'.resize(<count>)
" command! -bar -nargs=1 Dmove
"   \ call luaeval('require"utils.m.drawer.win".move(_A[1])', [<q-args>])
" command! -nargs=+ -count=1 Tsend
"   \ call luaeval('require"utils.m.drawer.term".send(_A[1], _A[2])', [<count>, <q-args>])

augroup m_drawer
  autocmd!
  autocmd BufWinEnter * lua require 'utils.m.drawer.win'._bufwinenter()
augroup end


" function s:diff_original() abort
"   if exists('b:diff_current')
"     execute bufwinnr(b:diff_current) 'wincmd w'
"   endif
"   if exists('b:diff_original')
"     diffoff
"     execute b:diff_original 'bwipeout'
"     unlet b:diff_original
"     return
"   endif
"
"   let bufnr = bufnr('%')
"   let ft = &l:filetype
"   let fenc = &l:fileencoding
"
"   if &modified
"     let source = '#' .. bufnr
"     let file = '[last save]'
"   else
"     echo 'There is not the diff.'
"     return
"   endif
"
"   vertical new
"
"   let b:diff_current = bufnr
"   let bufnr = bufnr('%')
"   setlocal buftype=nofile
"   let &l:filetype = ft
"   let &l:fileencoding = fenc
"   file `=file .. fnamemodify(bufname(b:diff_current), ':.')`
"
"   silent! execute 'read' source
"
"   0 delete _
"   diffthis
"   wincmd p
"   diffthis
"   let b:diff_original = bufnr
" endfunction
" nnoremap <Space>bz <Cmd>call <SID>diff_original()<CR>
"
"  command! Diff execute s:diff_original()
