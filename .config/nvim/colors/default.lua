-- from https://github.com/Bekaboo/nvim/blob/master/lua/colors/default.lua
-- Name:         default
-- Description:  Improves default colorscheme
-- Author:       Bekaboo <kankefengjing@gmail.com>
-- Modified:     Huda <muhamadhuda519@gmail.com>
-- License:      GPL-3.0
-- Last Updated: Mon 20 Jan 2025 00:18:29 AM WIB

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

-- stylua: ignore start
vim.api.nvim_set_hl(0, 'Comment', { fg = 'NvimDarkGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'NvimDarkGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'NonText', { fg = 'NvimDarkGrey4', ctermfg = 8 })
vim.api.nvim_set_hl(0, 'SpellBad', { underdashed = true, cterm = {} })
vim.api.nvim_set_hl(0, 'FloatTitle', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, "LineflyNormal", { bg = "#007373", fg = "white" })
vim.api.nvim_set_hl(0, "LineflyInsert", { bg = "#2563eb", fg = "white" })
vim.api.nvim_set_hl(0, "LineflyVisual", { bg = "#7e22ce", fg = "white" })
vim.api.nvim_set_hl(0, "LineflyReplace", { bg = "#b45309", fg = "white" })
vim.api.nvim_set_hl(0, "LineflyCommand", { bg = "#b91c1c", fg = "white" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "StatusLineTermNC", { fg = "#d1d5db"  })
vim.api.nvim_set_hl(0, "Visual", { bg = "#c4c6cd"  })
vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#c4c6cd"  })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#e0e2ea"  })

-- Define custom colors for MiniDiff signs
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#007373", bold = true }) -- Green for added lines
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#2563eb", bold = true }) -- Yellow for changed lines
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#b91c1c", bold = true }) -- Red for deleted lines

vim.api.nvim_set_hl(0, 'MatchParen', { reverse = true })

-- stylua: ignore end

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
