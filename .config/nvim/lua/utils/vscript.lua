vim.g.asyncrun_exit = "echo 'Success'"
vim.g.asyncrun_open =  20

vim.cmd([[
function! Gat(method) abort
    let &opfunc = a:method
    return "g@"
endfunction

nnoremap <expr><f9> Gat("v:lua.print")
command! -nargs=+ -complete=file MyEdit
				\ for f in expand(<q-args>, 0, 1) |
				\ exe '<mods> split ' .. f |
				\ endfor

		    function! SpecialEdit(files, mods)
			for f in expand(a:files, 0, 1)
			    exe a:mods .. ' split ' .. f
			endfor
		    endfunction
		    command! -nargs=+ -complete=file Sedit
				\ call SpecialEdit(<q-args>, <q-mods>)

	nnoremap <expr> <F7> CountSpaces()
	xnoremap <expr> <F7> CountSpaces()
	" doubling <F4> works on a line
	nnoremap <expr> <F7><F7> CountSpaces() .. '_'

	function CountSpaces(context = {}, type = '') abort
	  if a:type == ''
	    let context = #{
	      \ dot_command: v:false,
	      \ extend_block: '',
	      \ virtualedit: [&l:virtualedit, &g:virtualedit],
	      \ }
	    let &operatorfunc = function('CountSpaces', [context])
	    set virtualedit=block
	    return 'g@'
	  endif

	  let save = #{
	    \ clipboard: &clipboard,
	    \ selection: &selection,
	    \ virtualedit: [&l:virtualedit, &g:virtualedit],
	    \ register: getreginfo('"'),
	    \ visual_marks: [getpos("'<"), getpos("'>")],
	    \ }

	  try
	    set clipboard= selection=inclusive virtualedit=
	    let commands = #{
	      \ line: "'[V']",
	      \ char: "`[v`]",
	      \ block: "`[\<C-V>`]",
	      \ }[a:type]
	    let [_, _, col, off] = getpos("']")
	    if off != 0
	      let vcol = getline("'[")->strpart(0, col + off)->strdisplaywidth()
	      if vcol >= [line("'["), '$']->virtcol() - 1
	        let a:context.extend_block = '$'
	      else
	        let a:context.extend_block = vcol .. '|'
	      endif
	    endif
	    if a:context.extend_block != ''
	      let commands ..= 'oO' .. a:context.extend_block
	    endif
	    let commands ..= 'y'
	    execute 'silent noautocmd keepjumps normal! ' .. commands
	    echomsg getreg('"')->count(' ')
	  finally
	    call setreg('"', save.register)
	    call setpos("'<", save.visual_marks[0])
	    call setpos("'>", save.visual_marks[1])
	    let &clipboard = save.clipboard
	    let &selection = save.selection
	    let [&l:virtualedit, &g:virtualedit] = get(a:context.dot_command ? save : a:context, 'virtualedit')
	    let a:context.dot_command = v:true
	  endtry
	endfunction
nnoremap <F6> <Cmd>let &opfunc='{t ->
				\ getline(".")
				\ ->split("\\zs")
				\ ->insert("\"", col("'']"))
				\ ->insert("\"", col("''[") - 1)
				\ ->join("")
				\ ->setline(".")}'<CR>g@

map <C-J> <Plug>(edgemotion-j)
map <C-K> <Plug>(edgemotion-k)

let g:asterisk#keeppos = 1
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

highlight! link SignatureMarkText WarningMsg

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

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

