return {
  module = 'mini.tabline',
  lazy = false,
  config = function()
    local function get_buf_index(buf_id)
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      for i, id in ipairs(bufs) do
        if id.bufnr == buf_id then return i end
      end
      return nil
    end

    local MiniTabline = require('mini.tabline')

    MiniTabline.setup({
      -- Whether to show file icons (requires 'mini.icons')
      show_icons = false,
      format = function(buf_id, label)
        label = label == '*' and '[No Name]' or label
        local buf_index = get_buf_index(buf_id) or ''
        local suffix = vim.bo[buf_id].modified and '+ ' or ''
        return MiniTabline.default_format(buf_id, buf_index .. ' ' .. label) .. suffix
      end,
      tabpage_section = 'left',
    })

    local keys = '123456789'
    for i = 1, #keys do
      local key = keys:sub(i, i)
      local key_combination = string.format('g%s', key)
      vim.keymap.set('n', key_combination, function()
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        local target = buffers[i]
        if target then
          vim.api.nvim_set_current_buf(target.bufnr)
        else
          vim.notify('Buffer #' .. i .. ' not found', vim.log.levels.WARN)
        end
      end, { desc = 'Go to buffer ' .. i })
    end
  end,
}
