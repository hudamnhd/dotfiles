-------------------------------------------------------------------------------
-- Rules ==================================================
-------------------------------------------------------------------------------
local M = {}

local function modify_line_end_delimiter(character, config)
  return function()
    local line = vim.api.nvim_get_current_line()
    local last_char = line:sub(-1)

    if last_char == character then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(config.rules.delimiter_keys, last_char) then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      vim.api.nvim_set_current_line(line .. character)
    end
  end
end

function M.setup(config)
  local safe_for_each = require('native.utils').safe_for_each

  -- ( Disable ) ======================================================
  safe_for_each(config.rules.unmap_keys, function(key) vim.keymap.set('', key, '<Nop>') end)

  -- ( Blackhole ) ====================================================
  safe_for_each(config.rules.no_yank_keys, function(key) vim.keymap.set('', key, '"_' .. key) end)

  -- ( Delimiter ) ====================================================
  safe_for_each(
    config.rules.delimiter_keys,
    function(key)
      vim.keymap.set('n', 'd' .. key, modify_line_end_delimiter(key, config), {
        desc = 'Toggle end-of-line delimiter: ' .. key,
      })
    end
  )
end

return M
