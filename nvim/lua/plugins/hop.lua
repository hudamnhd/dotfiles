return {
  "smoka7/hop.nvim",
  event = { "BufReadPost" },
  config = function()
    require("hop").setup()
    local map = vim.keymap.set
    local hop = require("hop")
    local dir = require("hop.hint").HintDirection
    local opts = {
      AC = { direction = dir.AFTER_CURSOR },
      BC = { direction = dir.BEFORE_CURSOR },
      AC_LINE = { direction = dir.AFTER_CURSOR, current_line_only = true },
      BC_LINE = { direction = dir.BEFORE_CURSOR, current_line_only = true },
      LINE = {
        current_line_only = true,
        -- hint_position = require("hop.hint").HintPosition.END,
      },
    }

-- stylua: ignore start
    map("", "f",  function() hop.hint_char1(opts.LINE) end, { desc = "hint_char1" })
    map("n", "ss",  function() hop.hint_char2() end, { desc = "hint_char1" })
    map("", "F",  function() hop.hint_words() end, { desc = "hint_words" })
    -- map("n", "ss", hop.hint_words)
    -- map("n", "a",  function() hop.hint_char2() end, { desc = "hint_char1" })
    -- map("", "fj", function() hop.hint_char1(opts.AC) end)
    -- map("", "fk", function() hop.hint_char1(opts.BC) end)
    -- map("", "fl", function() hop.hint_char1(opts.AC_LINE) end)
    -- map("", "fh", function() hop.hint_char1(opts.BC_LINE) end)
    -- map("", "Fj", function() hop.hint_words(opts.AC) end)
    -- map("", "Fk", function() hop.hint_words(opts.BC) end)
    -- map("", "Fl", function() hop.hint_words(opts.AC_LINE) end)
    -- map("", "Fh", function() hop.hint_words(opts.BC_LINE) end)

    -- stylua: ignore end
    vim.cmd([[
      hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
    ]])
  end,
}
