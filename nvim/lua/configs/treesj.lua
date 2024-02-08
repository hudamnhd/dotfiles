local tsj = require('treesj')

tsj.setup({
  use_default_keymaps = false,
  max_join_length = 1024,
})

---@param preset table?
---@return nil
-- For use default preset and it work with dot
vim.keymap.set('n', '<leader>j', require('treesj').toggle)
-- For extending default preset with `recursive = true`, but this doesn't work with dot
vim.keymap.set('n', '<leader>J', function() require('treesj').toggle({ split = { recursive = true } }) end)
