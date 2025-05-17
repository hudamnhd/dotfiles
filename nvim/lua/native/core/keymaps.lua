-------------------------------------------------------------------------------
-- Keymaps ====================================================================
-------------------------------------------------------------------------------
local U = require('native.utils')
local map, cmd = U.map, U.cmd

-- ( Overide defaults ) =======================================================
map.nvo({ ['0'] = [[:]] }, { remap = true })
map.n({
  ['dd'] = function() return (vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd') end,
  ['J'] = [['mz' . v:count1 . 'J`z']],
}, { expr = true })

-- Don't leave visual mode when changing indentation
map.x({ ['>'] = [[>gv]], ['<'] = [[<gv]] })

-- -- Move selected lines up/down in visual mode
-- map.x({
--   ['K'] = [[:move '<-2<CR>gv=gv]],
--   ['J'] = [[:move '>+1<CR>gv=gv]],
-- })

-- Helper visual mode
map.x({
  ['I'] = function() return vim.fn.mode():match('[vV]') and '<C-v>^o^I' or 'I' end,
  ['A'] = function() return vim.fn.mode():match('[vV]') and '<C-v>1o$A' or 'A' end,
}, { expr = true })

-- Buffer close
map.n({
  ['<space>q'] = cmd('bd'),
  ['<space>Q'] = cmd('bw'),
})
map.t({
  ['<a-x>'] = cmd('bw!'),
})

-- Keep matches center screen when cycling with n|N
map.n({
  ['n'] = [[nzzzv]],
  ['N'] = [[nzzzv]],
  ['<C-d>'] = [[<C-d>zz]],
  ['<C-u>'] = [[<C-u>zz]],
})

-- Remap navigation
map.nvo({
  ['<C-H>'] = [[^]],
  ['<C-L>'] = [[g_]],
  ['<C-Z>'] = [[%]],
}, { remap = true })

-- Move by visible lines
map.nvo({
  ['j'] = [[v:count == 0 ? 'gj' : 'j']],
  ['k'] = [[v:count == 0 ? 'gk' : 'k']],
}, { expr = true })

-- Update
map.n('<space>w', '<Cmd>update | redraw<CR>', { desc = 'Save' })

-- Copy/paste with system clipboard
map.n({
  ['<space>y'] = [["+y]],
  ['<space>p'] = [["+p]],
})
map.x({
  ['<space>y'] = [["+y]],
  ['<space>p'] = [["+P]],
})

-- Note: Paste in Visual with `P` to not copy selected text (`:h v_P`)
map.x('p', 'P', { desc = 'Paste in Visual with `P` to not copy selected text' })

-- Reselect latest changed, put, or yanked text
map.n('g<C-v>', '`[v`]', { desc = 'visual select last yank/paste' })

-- Search inside visual selection
map.x('g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

-- Window navigation
map.n({
  ['<a-w>'] = [[<C-w>w]],
})
map.t({
  ['<a-w>'] = [[<C-\><C-n><C-w>w]],
})

-- Window resize
map.n({
  ['<C-Up>'] = '<C-w>+',
  ['<C-Down>'] = '<C-w>-',
  ['<C-Left>'] = '<C-w><',
  ['<C-Right>'] = '<C-w>>',
})

-- Newline without insert mode
map.n({
  ['<space>o'] = [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
  ['<space>O'] = [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
}, { desc = 'Newline without insert mode' })
map.i({
  ['<C-G><C-J>'] = '<C-G>u<C-O>o',
  ['<C-G><C-K>'] = '<C-G>u<C-O>O',
})

-- Transform case
map.n({
  ['cl'] = [[mzguiw`z]],
  ['ct'] = [[mzguiwgUl`z]],
  ['cu'] = [[mzgUiw`z]],
})

-- Helper terminal
map.t({
  ['<c-\\>'] = [[<C-\><C-n>]],
  ['<a-r>'] = [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
})

-- Helper cmdline
map.c({
  ['<C-V>'] = [[<C-R>"]],
  ['<C-G><C-V>'] = [[<C-R>+]],
  ['<C-G><C-S>'] = [[.\{-}]],
  ['<C-G><C-G>'] = [[\(\)<Left><Left>]],
  ['<C-G><C-W>'] = [[\<\><Left><Left>]],
  ['<C-G><C-O>'] = [[()<Left>]],
  ['<C-G><C-B>'] = [[{}<Left>]],
  ['<C-G><C-A>'] = [[<><Left>]],
  ['<C-G><C-I>'] = [[""<Left>]],
}, { remap = true, silent = false })
