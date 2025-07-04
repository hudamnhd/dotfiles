local fzf = require('fzf-lua')

-- See :help fzf-lua-customization
fzf.setup({
  'max-perf',
  winopts = {
    height = 0.59,
    width = 0.90,
    row = 0.48,
    col = 0.45,
    preview = {
      hidden = true,
      vertical = 'up:45%',
    },
  },
  keymap = {
    builtin = {
      true,
      ['<C-_>'] = 'toggle-preview',
    },
    fzf = {
      true,
      ['ctrl-d'] = 'preview-down',
      ['ctrl-u'] = 'preview-up',
      ['ctrl-/'] = 'toggle-preview',
    },
  },
  builtin = {
    actions = {
      ['ctrl-g'] = {
        fn = function() vim.cmd('FzfLua builtin query=git_') end,
      },
      ['ctrl-l'] = {
        fn = function() vim.cmd('FzfLua builtin query=lsp') end,
      },
      ['ctrl-s'] = {
        fn = function() vim.cmd('FzfLua builtin query=grep_') end,
      },
    },
  },
})

--See :help fzf-lua-neovim-api
fzf.register_ui_select(function(o, items)
  local min_h, max_h = 0.15, 0.70
  local preview = o.kind == 'codeaction' and 0.20 or 0
  local h = (#items + 4) / vim.o.lines + preview
  if h < min_h then
    h = min_h
  elseif h > max_h then
    h = max_h
  end
  return { winopts = { height = h, width = 0.60, row = 0.40 } }
end)

-- Shortcut cmd Find files
vim.api.nvim_create_user_command('F', function(info) fzf.files({ cwd = info.fargs[1] }) end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Fzf find files.',
})

-- custom fzf
local custom = {
  lsp = function() fzf.builtin({ query = 'lsp_' }) end,
  git = function() fzf.builtin({ query = 'git_' }) end,
  config = function() fzf.files({ cwd = vim.fn.stdpath('config') }) end,
  bcword = function() fzf.blines({ start = 'cursor', query = vim.fn.expand('<cword>') }) end,
  diagnostics = function(opts)
    return fzf.diagnostics_workspace(vim.tbl_extend('force', opts or {}, {
      prompt = 'Workspace Diagnostics> ',
    }))
  end,
  help = function()
    local ok = pcall(vim.cmd.help, vim.fn.expand('<cWORD>'))
    if not ok then fzf.help_tags({ query = vim.fn.expand('<cword>') }) end
  end,
}

local Fzf = vim.tbl_deep_extend('force', vim.deepcopy(require('fzf-lua')), custom)

-- stylua: ignore start
vim.keymap.set('n', 'z=',         Fzf.spell_suggest,   { desc = 'Open spell suggest picker' })
vim.keymap.set('n', '<F1>',       Fzf.help,            { desc = 'Open nvim help picker' })
vim.keymap.set('',  '<C-f>',      Fzf.builtin,         { desc = 'Open builtin picker' })
vim.keymap.set('n', '<Leader>8',  Fzf.bcword,          { desc = 'Open buffer word picker' })
vim.keymap.set('n', '<Leader>f',  Fzf.files,           { desc = 'Open file picker' })
vim.keymap.set('v', '<Leader>sg', Fzf.grep_visual,     { desc = 'Open search visual picker' })
vim.keymap.set('n', '<Leader>sg', Fzf.grep_cword,      { desc = 'Open search word picker' })
vim.keymap.set('n', '<Leader>si', Fzf.grep,            { desc = 'Open search input picker' })
vim.keymap.set('n', '<Leader>sf', Fzf.git_files,       { desc = 'Open gitfiles picker' })
vim.keymap.set('n', '<Leader>so', Fzf.oldfiles,        { desc = 'Open oldfiles picker' })
vim.keymap.set('n', '<Leader>sb', Fzf.buffers,         { desc = 'Open buffer picker' })
vim.keymap.set('n', '<Leader>sd', Fzf.diagnostics,     { desc = 'Open diagnostics picker' })
vim.keymap.set('n', '<Leader>sr', Fzf.resume,          { desc = 'Open last picker' })
vim.keymap.set('n', '<Leader>sc', Fzf.command_history, { desc = 'Open command history picker' })
vim.keymap.set('n', '<Leader>sh', Fzf.search_history,  { desc = 'Open search history picker' })
vim.keymap.set('n', '<Leader>sk', Fzf.keymaps,         { desc = 'Open nvim keymap picker' })
vim.keymap.set('n', '<Leader>sn', Fzf.config,          { desc = 'Open nvim config picker' })
vim.keymap.set('i', '<C-x><C-f>', Fzf.complete_path,   { desc = 'Open complete path picker' })
vim.keymap.set('i', '<C-x><C-l>', Fzf.complete_line,   { desc = 'Open complete line picker' })
-- stylua: ignore end
