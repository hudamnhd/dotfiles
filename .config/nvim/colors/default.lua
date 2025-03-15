-- stylua: ignore start
vim.cmd.hi("clear")
vim.g.colors_name = "default"

-- #004c73 (Dark blue)
-- #007373 (Dark cyan)
-- #005523 (Dark green)
-- #07080d (Dark grey1)
-- #14161b (Dark grey2)
-- #2c2e33 (Dark grey3)
-- #4f5258 (Dark grey4)
-- #470045 (Dark magenta)
-- #590008 (Dark red)
-- #6b5300 (Dark yellow)
-- #a6dbff (Light blue)
-- #8cf8f7 (Light cyan)
-- #b3f6c0 (Light green)
-- #eef1f8 (Light grey1)
-- #e0e2ea (Light grey2)
-- #c4c6cd (Light grey3)
-- #9b9ea4 (Light grey4)
-- #ffcaff (Light magenta)
-- #ffc0b9 (Light red)
-- #fce094 (Light yellow)

vim.api.nvim_set_hl(0, 'Comment', { fg = 'NvimLightGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'DirvishSuffix', { fg = 'NvimLightGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'NvimLightGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'NonText', { fg = 'NvimDarkGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NvimDarkGrey3' })

vim.api.nvim_set_hl(0, 'MatchParen', { reverse = true })

-- stylua: ignore end

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
