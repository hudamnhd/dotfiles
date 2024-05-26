-- Name:         default
-- Description:  Improves default colorscheme
-- Author:       Bekaboo <kankefengjing@gmail.com>
-- Maintainer:   Bekaboo <kankefengjing@gmail.com>
-- License:      GPL-3.0
-- Last Updated: Wed 03 Jan 2024 01:53:29 AM CST

vim.cmd.hi('clear')
vim.g.colors_name = 'default'

if vim.go.background == 'dark' then

  vim.api.nvim_set_hl(0, "Function",                  { bold = false })
  vim.api.nvim_set_hl(0, "TabLineSel",                { fg = "#011627", bg = "#7c8f8f" })
  vim.api.nvim_set_hl(0, "TabLineIndexSel",           { fg = "#011627", bg = "#7c8f8f" })
  vim.api.nvim_set_hl(0, "TabLineDividerSel",         { fg = "#ff9e3b", bg = "#7c8f8f" })
  vim.api.nvim_set_hl(0, "TabLineModifiedSel",        { fg = "#011627", bg = "#ff9e3b" })
  vim.api.nvim_set_hl(0, "TabLineIndexModifiedSel",   { fg = "#011627", bg = "#ff9e3b" })
  vim.api.nvim_set_hl(0, "TabLineDividerModifiedSel", { fg = "#ff9e3b", bg = "none" })
  vim.api.nvim_set_hl(0, "TabLine",                   { fg = "#eeeeee", bg = "#3E4452" })
  vim.api.nvim_set_hl(0, "TabLineDivider",            { fg = "#eeeeee", bg = "#3E4452" })
  vim.api.nvim_set_hl(0, "TabLineDividerVisible",     { fg = "#eeeeee", bg = "#3E4452" })
  vim.api.nvim_set_hl(0, "TabLineIndexVisible",       { fg = "#eeeeee", bg = "#3E4452" })
  vim.api.nvim_set_hl(0, 'LineNr',                    { fg = 'NvimLightGrey4', ctermfg = 8 })
  -- vim.api.nvim_set_hl(0, 'Comment',                   { fg = 'NvimDarkGrey5', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'NonText',                   { fg = 'NvimDarkGrey4', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'SpellBad',                  { underdashed = true, cterm = {} })
  -- vim.api.nvim_set_hl(0, 'NormalFloat',               { bg = 'NvimDarkGrey1', ctermbg = 7, ctermfg = 0, })
end

-- stylua: ignore start
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = 'NvimLightGreen', ctermfg = 10 })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = 'NvimLightBlue', ctermfg = 12 })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = 'NvimDarkRed', ctermfg = 9 })
vim.api.nvim_set_hl(0, 'GitSignsDeletePreview', { bg = 'NvimDarkRed', ctermbg = 9 })
-- stylua: ignore end

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
