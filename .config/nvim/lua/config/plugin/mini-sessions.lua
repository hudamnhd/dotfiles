return {
  module = 'mini.sessions',
  lazy = false,
  opts = {},
  config = function()
    -- See :help MiniSessions
    local sessions = require('mini.sessions')
    local actions = {
      delete_session = sessions.delete,
      switch_session = function()
        vim.cmd('wa')
        sessions.write()
        sessions.select()
      end,
      write_session = function()
        local cwd = vim.fn.getcwd():match('([^/]+)$')
        sessions.write(cwd)
      end,
      load_session = function()
        vim.cmd('wa')
        sessions.select()
      end,
    }

    vim.keymap.set('n', '<Leader>zs', actions.switch_session, { desc = 'Switch Session' })
    vim.keymap.set('n', '<Leader>zw', actions.write_session, { desc = 'Write Session' })
    vim.keymap.set('n', '<Leader>zl', actions.load_session, { desc = 'Load Session' })
    vim.keymap.set('n', '<Leader>zd', actions.delete_session, { desc = 'Delete Session' })
  end,
}
