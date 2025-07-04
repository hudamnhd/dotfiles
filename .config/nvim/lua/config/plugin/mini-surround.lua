return {
  module = 'mini.surround',
  --See :help MiniSurround-vim-surround-config
  opts = {
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cs',
      update_n_lines = '',
    },
  },
  config = function()
    -- unmap config generated `ys` mapping, prevents visual mode yank delay
    if vim.keymap then
      vim.keymap.del('x', 'ys')
    else
      vim.cmd('xunmap ys')
    end

    -- Remap adding surrounding to Visual mode selection
    vim.keymap.set('x', 's', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = 'Surround add visual' })
    vim.keymap.set('n', 'yss', 'ys_', { remap = true })
  end,
}
