-- Load configuration files
require("options")
require("autocmd")
require("lazyplug")

-- Set colorscheme
pcall(vim.cmd, [[colorscheme default]])

-- Load utility modules
require("utils.mru")
require("utils.m.keymaps")

-- Define custom key mappings for visual and operator-pending modes
vim.cmd([[
  autocmd BufRead,BufWritePre *.blade.php setlocal ft=blade
  " autocmd BufRead,BufWritePre * setlocal syntax=c
  xmap <C-Z> %
  omap <C-Z> %
  nmap <C-Z> %
  xmap q iq
  omap q iq
  nnoremap <silent>zl :put! =printf('console.log(''%s:'',  %s);', expand('<cword>'), expand('<cword>'))<CR><cmd>move +1<cr>
]])

if vim.g.colors_name == "default" then
  vim.cmd("hi! link whitespace nontext")
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
end
