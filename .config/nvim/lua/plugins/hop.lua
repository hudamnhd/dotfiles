return {
  "smoka7/hop.nvim",
  event = { "BufReadPost" },
  config = function()
    require("hop").setup()
    local map = vim.keymap.set
    local hop = require("hop")
    local dir = require("hop.hint").HintDirection
    local pos = require("hop.hint").HintPosition
    local opts = {
      AC = { direction = dir.AFTER_CURSOR },
      BC = { direction = dir.BEFORE_CURSOR },
      AC_LINE = { direction = dir.AFTER_CURSOR, current_line_only = true },
      AC_LINE_E = {
        direction = dir.AFTER_CURSOR,
        current_line_only = true,
        hint_position = pos.END,
      },
      BC_LINE = { direction = dir.BEFORE_CURSOR, current_line_only = true },
      LINE = {
        current_line_only = true,
      },
    }

-- stylua: ignore start
    map("", "f",  function() hop.hint_char1(opts.LINE) end, { noremap = true, desc = "hint_char1" })

    map("", "sf",  function() hop.hint_char2() end, { noremap = true, desc = "hint_char2" })
    map("", "sj",  function() hop.hint_vertical(opts.AC) end, { noremap = true, desc = "hint_vertical_ac" })
    map("", "sk",  function() hop.hint_vertical(opts.BC) end, { noremap = true, desc = "hint_vertical_bc" })

    map("", "FF",  function() hop.hint_lines() end, { noremap = true, desc = "hint_lines" })
    map("", "FJ",  function() hop.hint_lines_skip_whitespace(opts.AC) end, { noremap = true, desc = "hint_lines_skip_whitespace_ac" })
    map("", "FK",  function() hop.hint_lines_skip_whitespace(opts.BC) end, { noremap = true, desc = "hint_lines_skip_whitespace_bc" })

    -- stylua: ignore end
    vim.cmd([[
      hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
    ]])
  end,
}
