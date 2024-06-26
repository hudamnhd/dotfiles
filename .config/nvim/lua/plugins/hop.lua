return {
  "smoka7/hop.nvim",
  keys = { "f", "F" },
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
    map("", "F",  function() hop.hint_words() end, { desc = "hint_words" })

    -- stylua: ignore end
    vim.cmd([[
      hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
      hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff
    ]])
  end,
}
