-- Load configuration files
require("options")
require("autocmd")
require("lazyplug")

-- Set colorscheme
pcall(vim.cmd, [[colorscheme catppuccin]])

-- Load utility modules
require("utils.mru")
require("utils.m")
require("utils.m.global")
require("utils.m.keymaps")
-- require('utils.m.ui.statusline').setup()

-- Adjust highlighting for kanagawa colorscheme
if vim.g.colors_name == "catppuccin" then
  vim.cmd("hi! link whitespace nontext")
end

-- Define custom key mappings for visual and operator-pending modes
vim.cmd([[
  autocmd BufRead,BufWritePre *.blade.php setlocal ft=php
  xmap <C-Z> %
  omap <C-Z> %
  nmap <C-Z> %
  xmap q iq
  omap q iq
  nnoremap <silent>zl :put! =printf('console.log(''%s:'',  %s);', expand('<cword>'), expand('<cword>'))<CR><cmd>move +1<cr>
]])

vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#011627", bg = "#9CABCA" })
vim.api.nvim_set_hl(0, "TabLineIndexSel", { fg = "#011627", bg = "#9CABCA" })
vim.api.nvim_set_hl(0, "TabLineDividerSel", { fg = "#ff9e3b", bg = "#9CABCA" })
vim.api.nvim_set_hl(0, "TabLineModifiedSel", { fg = "#011627", bg = "#ff9e3b" })
vim.api.nvim_set_hl(0, "TabLineIndexModifiedSel", { fg = "#011627", bg = "#ff9e3b" })
vim.api.nvim_set_hl(0, "TabLineDividerModifiedSel", { fg = "#ff9e3b", bg = "none" })
vim.api.nvim_set_hl(0, "TabLine", { fg = "#eeeeee", bg = "#223249" })
vim.api.nvim_set_hl(0, "TabLineDivider", { fg = "#eeeeee", bg = "#223249" })
vim.api.nvim_set_hl(0, "TabLineDividerVisible", { fg = "#eeeeee", bg = "#223249" })
vim.api.nvim_set_hl(0, "TabLineIndexVisible", { fg = "#eeeeee", bg = "#223249" })
vim.api.nvim_set_hl(0, "TabLineIndexModified", { fg = "#ff9e3b", bg = "#223249", bold = true })
vim.api.nvim_set_hl(0, "TabLineModified", { fg = "#ff9e3b", bg = "#223249", bold = true })

-- local hls = {
-- gitsignscurrentlineblame = { fg = "#f9e2af" },
-- buffercurrenttarget = { bg = "#ff00ff", bold = true, fg = "#ffffff" },
-- buffercurrentnumber = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- buffercurrent = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- buffervisible = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- buffervisiblesign = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- buffervisiblenumber = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- buffercurrentsign = { fg = "#a6e3a1", bg = "#45475a", bold = true },
-- bufferinactive = { fg = "#dcd7ba" },
-- bufferinactivesign = { fg = "#b4bddc" },
-- bufferinactivenumber = { fg = "#dcd7ba" },
-- bufferinactivetarget = { bg = "#ff00ff", bold = true, fg = "#ffffff" },
-- buffervisibletarget = { bg = "#ff00ff", bold = true, fg = "#ffffff" },
--   }
--   for hl_group, hl in pairs(hls) do
--     hl.default = false
--     vim.api.nvim_set_hl(0, hl_group, hl)
--   end
