-------------------------------------------------------------------------------
-- Substitute =================================================================
-------------------------------------------------------------------------------
local U = require('native.utils')
local get_visual_selection, double_escape = U.get_visual_selection, U.double_escape

-- Helper substitute visual mode
local visual_charwise_selection = function()
  local visual_selection = get_visual_selection()

  if visual_selection == nil then
    print('search-replace does not support visual-blockwise selections')
    return
  end

  local backspace_keypresses = string.rep('\\<backspace>', 5)
  local left_keypresses = string.rep('\\<Left>', 2)

  vim.cmd(
    ':call feedkeys(":'
      .. backspace_keypresses
      .. '%s/'
      .. double_escape(visual_selection)
      .. '/'
      .. double_escape(visual_selection)
      .. '/'
      .. 'g'
      .. left_keypresses
      .. '")'
  )
end

local left = function(count) return string.rep('<left>', count) end

local substitute = {
  selection = visual_charwise_selection,
  cword = ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI' .. left(3),
  vcword = ":'<,'>s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI" .. left(3),
  cWord = ':%s/\\V<C-r><C-a>/<C-r><C-a>/gI' .. left(3),
  buffer = ':%s/\\v//gI' .. left(4),
  visual = ':s/\\v//gI' .. left(4),
}
-------------------------------------------------------------------------------
-- Multi Cursor ===============================================================
-------------------------------------------------------------------------------
-- see: http://www.kevinli.co/p<space>pnosts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript
local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
local mc_macro = function(selection)
  selection = selection or ''

  return function()
    if vim.fn.reg_recording() == 'z' then return 'q' end

    if vim.fn.getreg('z') ~= '' then return 'n@z' end

    return selection .. '*Nqz'
  end
end

vim.keymap.set('n', '<F7>', [[*Nqz]], { desc = 'mc start macro (foward)' })
vim.keymap.set('n', '<F8>', mc_macro(), { desc = 'mc end or replay macro', expr = true })
vim.keymap.set('x', '<F7>', mc_select .. '``qz', { desc = 'mc start macro (foward)' })
vim.keymap.set('x', '<F8>', mc_macro(mc_select), { desc = 'mc end or replay macro', expr = true })

vim.keymap.set('n', '<C-G><C-F>', substitute.cword, { silent = false, desc = ':%s/<cword>/<cword>/gI' })
vim.keymap.set('n', '<C-G><C-A>', substitute.cWord, { silent = false, desc = ':%s/<cWORD>/<cWORD>/gI' })
vim.keymap.set('n', '<C-G><C-S>', substitute.buffer, { silent = false, desc = ':%s/\\v../../gI' })

vim.keymap.set('n', '<C-G><C-B>', substitute.vcword, { silent = false, desc = ":'<, '>s/<cword>/<cword>/gI" })
vim.keymap.set('x', '<C-G><C-S>', substitute.visual, { silent = false, desc = ':s/\\v ../../gI' })
vim.keymap.set('x', '<C-G><C-F>', substitute.selection, { silent = false, desc = ':%s/<selection>/<selection>/gI' })

-- Global Search Replace Quickfix
-- * `:cdo` = "run every line in Quickfix"  | :cdo %s/foo/bar/g  | update
-- * `:cfdo` = "run every file in Quickfix" | :cfdo %s/foo/bar/g | update

-- Alternate cgn for easy press
vim.keymap.set('n', '<bs>', '*N"_cgn', { desc = 'cgn' })
