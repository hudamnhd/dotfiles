require('mini.move').setup( -- No need to copy this inside `setup()`. Will be used automatically.
  {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-h>',
      right = '<M-l>',
      down = '<M-j>',
      up = '<M-k>',

      -- Move current line in Normal mode
      line_left = '<M-h>',
      line_right = '<M-l>',
      line_down = '<M-j>',
      line_up = '<M-k>',
    },

    options = {
      reindent_linewise = true,
    },
  }
)

require('mini.operators').setup({
  evaluate = {
    prefix = 'g=',
    func = nil,
  },
  exchange = {
    prefix = 'gx',
    reindent_linewise = true,
  },
  multiply = {
    prefix = 'gm',
    func = nil,
  },
  replace = {
    prefix = 'gr',
    reindent_linewise = true,
  },
  sort = {
    prefix = 'gz',
    func = nil,
  },
})


require('mini.indentscope').setup({
  draw = {
    delay = 100,
    animation = function(_, _)
      return 5
    end,
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = 'ii',
    object_scope_with_border = 'ai',
    -- Motions (jump to respective border line; if not present - body line)
    goto_top = '<a-[>',
    goto_bottom = '<a-]>',
  },
  options = {
    border = 'both',
    indent_at_cursor = true,
    try_as_border = true,
  },
  -- alternative styles: ┆ ┊ ╎
  symbol = '╎',
})

local M = {}

M.toggle = function(bufnr)
  if bufnr then
    vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
  else
    vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
  end
  -- require("mini.indentscope").auto_draw({ lazy = true })
end

M.btoggle = function()
  M.toggle(vim.api.nvim_get_current_buf())
end

return M
