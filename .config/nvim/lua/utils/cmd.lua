-- Define custom key mapp
-- ings for visual and operator-pending modes
vim.cmd([[

let g:asyncrun_open =  20

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"autocmd BufRead,BufWritePre * setlocal syntax=c
autocmd BufRead,BufWritePre *.blade.php setlocal syntax=c
 augroup vimrc

   autocmd!

   autocmd BufWinEnter,Syntax * syn sync minlines=500 maxlines=500

 augroup END

function! SetCustomMappings()
  if &filetype == 'lua'
    nnoremap <buffer> <silent> zl :put! =printf('vim.inspect(''%s:'',  %s);', expand('<cword>'), expand('<cword>'))<CR><cmd>move +1<CR>
  elseif &filetype == 'javascript' || &filetype == 'typescript' || &filetype == 'javascriptreact' || &filetype == 'typescriptreact'
    nnoremap <buffer> <silent> zl :put! =printf('console.log(''%s:'',  %s);', expand('<cword>'), expand('<cword>'))<CR><cmd>move +1<CR>
  endif
endfunction

" Set autocommand to call the function based on filetype
augroup CustomMappings
  autocmd!
  autocmd FileType lua call SetCustomMappings()
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact call SetCustomMappings()
augroup END

"hi! link whitespace nontext
hi MiniJump2dDim       cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
hi MiniJump2dSpot       cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
hi MiniJump2dSpotAhead  cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
hi MiniJump2dSpotUnique cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff

xmap <C-Z> %
omap <C-Z> %
nmap <C-Z> %
xmap q iq
omap q iq

" /<BS>: Inverse search (line NOT containing pattern).
"cnoremap <expr> <BS> (getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'
" Hit space to match multiline whitespace.
cnoremap <expr> <Space> getcmdtype() =~ '[/?]' ? '\_s\+' : ' '
" //: "Search within visual selection".
cnoremap <expr> / (mode() =~# "[vV\<C-v>]" && getcmdtype() =~ '[/?]' && getcmdline() == '') ? "\<C-c>\<Esc>/\\%V" : '/'

nnoremap ' `
nnoremap ; :

" niceblock
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>1o$A':'A')

"Relative with start point or with line number or absolute number lines

function! ToggleRelativeNumber()
    if &relativenumber
          set norelativenumber
          set nu!
    else
          set relativenumber
          set nu!
    endif

endfunction

nmap \n :call ToggleRelativeNumber()<CR>

" Insert formatted datetime (from @tpope vimrc)
inoremap <silent> <C-X><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>
" Print unix time at cursor as human-readable datetime. 1677604904 => '2023-02-28 09:21:45'
"nnoremap gA :echo strftime('%Y-%m-%d %H:%M:%S', '<c-r><c-w>')<cr>

" Repeat last command for each line of a visual selection.
xnoremap . :normal .<CR>
" Repeat the last edit on the next [count] matches.
nnoremap <silent> gn :normal n.<CR>

func! s:zoom_toggle(cnt) abort
  if a:cnt  " Fallback to default '|' behavior if count was provided.
    exe 'norm! '.v:count.'|'
  endif

  if 1 == winnr('$')
    return
  endif
  let restore_cmd = winrestcmd()
  wincmd |
  wincmd _
  if exists('t:zoom_restore')
    exe t:zoom_restore
    unlet t:zoom_restore
  elseif winrestcmd() !=# restore_cmd
    let t:zoom_restore = restore_cmd
  endif
endfunc
nnoremap sm     :<C-U>call <SID>zoom_toggle(v:count)<CR>

augroup vimrc_autocmd
  autocmd!
  " Defaults for text-like buffers.
  autocmd VimEnter,BufNew * autocmd InsertEnter <buffer=abuf> ++once if &filetype ==# '' | exe 'runtime! after/ftplugin/text.vim' | endif
  autocmd FileType markdown,gitcommit runtime! after/ftplugin/text.vim

augroup END

" _opt-in_ to sloppy-search https://github.com/neovim/neovim/issues/3209#issuecomment-133183790
"nnoremap df :edit **/

" special-purpose mappings/commands ===========================================
"nnoremap <leader>vv   :exe 'e' fnameescape(resolve($MYVIMRC))<cr>
"nnoremap <leader>vp   :exe 'e' stdpath('config')..'/lua/plugins/init.lua'<cr>

"nnoremap s= <cmd>set paste<cr>o<cr><c-r>=repeat('=',80)<cr><cr><c-r>=strftime('%Y%m%d')<cr><cr>.<cr><c-r>+<cr>tags: <esc><cmd>set nopaste<cr>
"command! InsertCBreak         norm! i#include <signal.h>
"nnoremap <expr> gb v:count ? ':<c-u>'.v:count.'buffer<cr>' : ':set nomore<bar>ls<bar>set more<cr>:buffer<space>'
nnoremap df :edit **/*
nnoremap sf :find <C-R>=expand('%:h').'/*'<CR>
"nnoremap gb :ls<CR>:b<Space>
]])


-- function GeneratePassword(len, use_types)
--     local char_types = {
--         upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
--         lower = "abcdefghijklmnopqrstuvwxyz",
--         num = "0123456789",
--         marks = [[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]],
--         space = " "
--     }
--
--     char_types.all = char_types.upper .. char_types.lower .. char_types.num .. char_types.marks .. char_types.space
--     char_types.alpha = char_types.upper .. char_types.lower
--     char_types.alnum = char_types.alpha .. char_types.num
--
--     local types = use_types and vim.split(use_types, ",") or { "alpha" }
--
--     local chars = ""
--     for _, type in ipairs(types) do
--         chars = chars .. (char_types[type] or "")
--     end
--
--     local password = ""
--     local chars_len = #chars
--
--     for _ = 1, len do
--         local rand_index = math.random(1, chars_len)
--         password = password .. chars:sub(rand_index, rand_index)
--     end
--
--     return password
-- end
-- local password = GeneratePassword(12, "upper,lower,num,marks")
-- print(password)

-- local augroup = vim.api.nvim_create_augroup("EnterRemap", {})
-- vim.api.nvim_clear_autocmds({ group = augroup })
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
--   group = augroup,
--   callback = function(data)
--     local buftype = vim.api.nvim_get_option_value("buftype", { buf = data.buf })
--     -- acwrite is the buftype for oil.nvim
--     if buftype == "quickfix" or buftype == "terminal" then
--       return
--     end
--     vim.api.nvim_buf_set_keymap(data.buf, "n", "<CR>", ":", { noremap = true })
--   end,
-- })
