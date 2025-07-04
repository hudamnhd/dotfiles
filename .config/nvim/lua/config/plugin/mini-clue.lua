return {
  module = 'mini.clue',
  config = function()
    local miniclue = require('mini.clue')

    -- Some builtin keymaps that I don't use and that I don't want mini.clue to show.
    for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
      vim.keymap.del('n', lhs)
    end

    miniclue.setup({
      triggers = {
        -- Builtins.
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'z' },
        -- Leader triggers.
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        -- Moving between stuff.
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
      },
      clues = {
        -- Leader/movement groups.
        { mode = 'n', keys = '<Leader>z', desc = '+Session' },
        { mode = 'n', keys = '<Leader>s', desc = '+Search' },
        { mode = 'n', keys = '<Leader>v', desc = '+Vim' },
        { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
        { mode = 'n', keys = '<Leader>g', desc = '+Git' },
        { mode = 'n', keys = '<Leader>c', desc = '+Code' },
        { mode = 'n', keys = '<Leader>x', desc = '+Loclist/Quickfix' },
        { mode = 'n', keys = '[', desc = '+prev' },
        { mode = 'n', keys = ']', desc = '+next' },
        -- Builtins.
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },

      window = {
        -- delay = 0,
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
        config = function(bufnr)
          local max_width = 0
          for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
            max_width = math.max(max_width, vim.fn.strchars(line))
          end

          -- Keep some right padding.
          max_width = max_width + 2

          return {
            anchor = 'SW',

            row = 'auto',
            col = 'auto',
            -- Dynamic width capped at 70.
            width = math.min(70, max_width),
          }
        end,
      },
    })
  end,
}
