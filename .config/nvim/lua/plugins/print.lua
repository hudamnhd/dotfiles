local function insert_json(pattern)
  local text = "<pre className='text-sm'>{JSON.stringify(" .. pattern .. ", null, 2)}</pre>"
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0) -- Cursor position as [line, column]
  local row = cursor[1] - 1 -- Convert to 0-based index for Neovim API

  vim.api.nvim_buf_set_lines(buf, row, row, false, { text })
end

local function logjs_opr()
  require("utils.search-replace").get_range(function(result)
    insert_json(result)
  end)
end

vim.keymap.set("n", "<space>dj", logjs_opr, { desc = "logjs_opr" })

return {
  "andrewferrier/debugprint.nvim",
  event = "BufReadPost",
  opts = {
    keymaps = {
      normal = {
        plain_below = "<space>dp",
        plain_above = "<space>dP",
        variable_below = "<space>dv",
        variable_above = "<space>dV",
        variable_below_alwaysprompt = "",
        variable_above_alwaysprompt = "",
        textobj_below = "<space>do",
        textobj_above = "<space>dO",
        toggle_comment_debug_prints = "",
        delete_debug_prints = "",
      },
      insert = {
        plain = "<C-G>p",
        variable = "<C-G>v",
      },
      visual = {
        variable_below = "<space>dv",
        variable_above = "<space>dV",
      },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
      reset_debug_prints_counter = "ResetDebugPrintsCounter",
    },
    -- … Other options
  },
  cmd = {
    "ToggleCommentDebugPrints",
    "DeleteDebugPrints",
  },
  version = "*",
  config = function(_, opts)
    require("debugprint").setup(opts)
  end,
}
