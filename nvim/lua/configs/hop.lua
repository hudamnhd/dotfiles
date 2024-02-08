require('hop').setup()
local map = vim.keymap.set
local hop = require('hop')
local opts = {
  LINE = { current_line_only = true },
}

-- stylua: ignore start
    map("", "sj", function() hop.hint_lines_skip_whitespace() end)
    map("", "ss", function() hop.hint_char1() end, { desc = "hint_char1" })
    map("", "F", hop.hint_words, { desc = "hint_words" })
    map("", "f", function() hop.hint_char1(opts.LINE) end, { desc = "hint_char1" })
-- stylua: ignore end

vim.cmd([[
      hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
    ]])
