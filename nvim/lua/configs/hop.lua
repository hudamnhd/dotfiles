require('hop').setup()
local map = vim.keymap.set
local hop = require('hop')
local opts = {
  LINE = {
    current_line_only = true,
    hint_position = require('hop.hint').HintPosition.END,
  },
}

-- stylua: ignore start
    map("",  "F",  function() hop.hint_char1(opts.LINE) end, { desc = "hint_char1" })
    map("",  "f",  function() hop.hint_words(opts.LINE) end, { desc = "hint_words" })
-- stylua: ignore end

vim.cmd([[
      hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
    ]])
