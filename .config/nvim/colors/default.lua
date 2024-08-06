-- from https://github.com/Bekaboo/nvim/blob/master/lua/colors/default.lua
-- Name:         default
-- Description:  Improves default colorscheme
-- Author:       Bekaboo <kankefengjing@gmail.com>
-- Maintainer:   Bekaboo <kankefengjing@gmail.com>
-- License:      GPL-3.0
-- Last Updated: Wed 03 Jan 2024 01:53:29 AM CST

vim.cmd.hi('clear')
vim.g.colors_name = 'default'

-- stylua: ignore start
if vim.go.background == 'dark' then
  vim.api.nvim_set_hl(0, 'Comment',     { fg = 'NvimDarkGrey5', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'LineNr',      { fg = 'NvimDarkGrey5', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'NonText',     { fg = 'NvimDarkGrey4', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'SpellBad',    { underdashed = true, cterm = {} })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NvimDarkGrey1', ctermbg = 7, ctermfg = 0,
  })
end
-- stylua: ignore end

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
