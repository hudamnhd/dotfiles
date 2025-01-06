local function insert_json(pattern)
  local text = "<pre className='text-sm'>{JSON.stringify(" .. pattern .. ", null, 2)}</pre>"
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0) -- Cursor position as [line, column]
  local row = cursor[1] - 1 -- Convert to 0-based index for Neovim API

  vim.api.nvim_buf_set_lines(buf, row, row, false, { text })
end

local function logjs_opr()
  require("utils.helper").get_range(function(result)
    insert_json(result)
  end)
end

vim.keymap.set("n", "<space>gj", logjs_opr, { desc = "logjs_opr" })

return {
  "andrewferrier/debugprint.nvim",
  event = "BufReadPost",
  opts = {
    keymaps = {
      normal = {
        plain_below = "<space>gp",
        plain_above = "<space>gP",
        variable_below = "<space>gv",
        variable_above = "<space>gV",
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
        textobj_below = "<space>go",
        textobj_above = "<space>gO",
        toggle_comment_debug_prints = nil,
        delete_debug_prints = nil,
      },
      visual = {
        variable_below = "<space>gv",
        variable_above = "<space>gV",
      },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
    },
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
