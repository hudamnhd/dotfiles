local autocmd = vim.api.nvim_create_autocmd
local groupid = vim.api.nvim_create_augroup
---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function augroup(group, ...)
  local id = groupid(group, {})
  for _, a in ipairs({ ... }) do
    a[2].group = id
    autocmd(unpack(a))
  end
end

augroup('UserBufferBehavior', {

  'Filetype',
  {
    pattern = { 'help', 'man' },
    callback = function()
      local buftype = vim.bo.buftype
      if buftype == 'help' or buftype == 'nofile' then
        vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true, nowait = true })
        vim.cmd('wincmd H')
      end
    end,
  },
}, {
  'TextYankPost',
  {
    desc = 'Highlight the selection on yank.',
    callback = function()
      pcall(vim.highlight.on_yank, {
        higroup = 'Search',
        timeout = 400,
      })
    end,
  },
}, {
  'BufReadPost',
  {
    pattern = '*',
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
    desc = 'Return to last edit position when opening files.',
  },
}, {
  'BufWritePre',
  {
    pattern = '*',
    command = [[%s/\s\+$//e]],
    desc = 'Delete Trailing Whitespace.',
  },
})
