--------------------------------------------------------------------------------
-- Keymaps                                            See :help vim.keymap.set()
--------------------------------------------------------------------------------
local keymap = {}

function keymap.custom()
  -- === BASIC MAPPINGS ===

  -- Swap ; :
  vim.keymap.set('', ';', ':', { noremap = true })
  vim.keymap.set('', ':', ';', { noremap = true })

  -- Disable
  for _, char in ipairs({ 's', 'q', '<S-u>', '<C-z>', '<Space>' }) do
    vim.keymap.set('', char, '<nop>')
  end

  -- Save / Quit
  vim.keymap.set('n', '<Leader>w', '<cmd>write<cr>', { desc = 'Save file' })
  vim.keymap.set('n', '<Leader>q', '<cmd>bd<cr>', { desc = 'Buf delete' })

  -- Navigate start/end of line
  vim.keymap.set({ 'n', 'v' }, '<C-h>', '^')
  vim.keymap.set({ 'n', 'v' }, '<C-l>', 'g_')

  -- Move between windows
  vim.keymap.set('n', '<A-w>', '<C-w>w')
  vim.keymap.set('n', '<A-p>', '<C-w>p')

  -- Terminal window switch
  vim.keymap.set('t', '<A-w>', [[<C-\><C-n><C-w>w]])
  vim.keymap.set('t', '<A-p>', [[<C-\><C-n><C-w>p]])
  vim.keymap.set('t', [[<C-\>]], [[<C-\><C-n>]]) -- Exit terminal mode

  -- Jump to match bracket
  vim.keymap.set({ 'n', 'v' }, '<C-z>', '%')

  -- Messages
  vim.keymap.set('n', '<Leader>m', '<cmd>messages<cr>', { desc = 'Show messages' })
  vim.keymap.set('n', '<Leader>M', '<cmd>messages clear<cr>', { desc = 'Clear messages' })

  -- === TEXT MANIPULATION ===

  -- Indent keep selection
  vim.keymap.set('v', '<', '<gv', {})
  vim.keymap.set('v', '>', '>gv', {})

  -- Move lines up/down
  -- vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv=gv", {})
  -- vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv=gv", {})

  -- Keep center on search
  vim.keymap.set('n', 'n', 'nzzzv', { desc = "Fwd search '/' or '?'" })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Back search '/' or '?'" })

  -- Join line with cursor stay
  vim.keymap.set('n', 'J', [['mz' . v:count1 . 'J`z']], { expr = true, desc = 'Join lines keep cursor' })

  -- Undo breakpoints
  for _, char in ipairs({ ',', ';', '.' }) do
    vim.keymap.set('i', char, char .. '<C-g>u')
  end

  -- Change word with search
  vim.keymap.set('n', '<Bs>', '*N"_cgn')
  vim.keymap.set('x', '<Bs>', [[<esc>/\V<C-r>=luaeval("config.get_visual_selection()")<CR><CR>N"_cgn]])

  -- Select last pasted/yanked
  vim.keymap.set('n', 'g<C-v>', '`[v`]', { desc = 'Visual select last yank/paste' })

  -- === CASE CONVERSION ===

  vim.keymap.set('n', 'cl', 'mzguiw`z', { desc = 'To lowercase' })
  vim.keymap.set('n', 'ct', 'mzguiwgUl`z', { desc = 'To titlecase' })
  vim.keymap.set('n', 'cu', 'mzgUiw`z', { desc = 'To uppercase' })

  -- === CLIPBOARD / BLACKHOLE ===

  -- Cut to blackhole
  for _, char in ipairs({ 'x', 'c', 'd' }) do
    vim.keymap.set(char ~= 'd' and { 'n', 'x' } or { 'n' }, char, '"_' .. char)
  end

  -- Paste without overwrite
  vim.keymap.set('x', 'p', [['pgv"' . v:register . 'y']], { expr = true, noremap = true, desc = 'Paste keep reg' })

  -- Clipboard
  vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
  vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste from clipboard' })

  -- File Explorer
  -- vim.keymap.set('n', '<Leader>e', '<cmd>Ex<cr>', { desc = 'Open netrw' })

  -- Search file (manual)
  -- vim.keymap.set('n', '<Leader>f', ':find ', { silent = false, desc = 'Search file' })

  -- === PICKER NAVIGATION ===

  -- vim.keymap.set('n', '<Leader>vb', ':ls<cr>:buffer ', { desc = 'Picker buffer' })
  -- vim.keymap.set('n', '<Leader>vu', ':undolist<cr>:undo ', { desc = 'Picker undolist' })
  -- vim.keymap.set('n', '<Leader>vw', ':g/<C-r><C-w>/#<cr>:', { desc = 'Picker g' })
  -- vim.keymap.set('n', '<Leader>vg', ':changes<cr>:normal! g;<S-Left>', { desc = 'Picker changes' })
  -- vim.keymap.set('n', '<Leader>vm', ':marks<cr>:normal! `', { desc = 'Picker mark' })
  -- vim.keymap.set('n', '<Leader>vo', ':oldfiles<cr>:edit #<', { desc = 'Picker oldfiles' })
  -- vim.keymap.set('n', '<Leader>vr', ':registers<cr>:normal! "p<left>', { desc = 'Picker register' })
  -- vim.keymap.set('n', '<Leader>vj', ':jumps<cr>:normal!<C-O><S-Left>', { desc = 'Picker jumps' })

  -- === SUBSTITUTE ===

  vim.keymap.set('n', '<Leader>r', ':%s///gI<left><left><left>', { silent = false, desc = 'Sub last search' })
  vim.keymap.set(
    'n',
    '<Leader>s',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { silent = false, desc = 'Sub word under cursor' }
  )
  vim.keymap.set(
    'x',
    '<Leader>s',
    [[:<C-u>%s/\V<C-r>=luaeval("config.get_visual_selection()")<cr>/<C-r>=luaeval("config.get_visual_selection()")<cr>/gI<Left><Left><Left>]],
    { silent = false, desc = 'Sub visual selection' }
  )

  -- Search in visual selection
  vim.keymap.set('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual' })

  -- === USEFUL ===

  -- Insert register content in terminal
  vim.keymap.set(
    't',
    '<M-r>',
    [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
    { expr = true, desc = 'Insert register terminal' }
  )

  -- Command line register insertion
  vim.keymap.set('c', '<C-v>', '<C-r>"', { desc = 'Insert default reg' })
  vim.keymap.set('c', '<A-v>', '<C-r>+', { desc = 'Insert system clipboard' })
  vim.keymap.set(
    'c',
    '<C-r><C-v>',
    [[<C-r>=luaeval("config.get_visual_selection(false)")<cr>]],
    { desc = 'Insert visual selection' }
  )

  -- Regex helper
  vim.keymap.set('c', '<F1>', [[\(.*\)]], { desc = 'Regex capture all' })
  vim.keymap.set('c', '<F2>', [[.\{-}]], { desc = 'Regex fuzzy match' })
  vim.keymap.set('c', '<C-g><C-g>', [[s/\v'(.{-})'//g]], { desc = "Delete '...'(multiline)" })
  vim.keymap.set('c', '<C-g><C-w>', [[s/\v(\w+)//g]], { desc = 'Delete word (\\w+)' })
  vim.keymap.set('c', '<C-g><C-b>', [[s/\v\(([^()]+)\)//g]], { desc = 'Delete inside (...)' })
  vim.keymap.set('c', '<C-g><C-d>', [[s/\v"([^"]+)"//g]], { desc = 'Delete inside "..."' })
  vim.keymap.set('c', '<C-g><C-q>', [[s/\v'([^']+)'//g]], { desc = "Delete inside '...'" })

  -- Visual Mode Enhancements
  vim.keymap.set(
    'v',
    'I',
    function() return vim.fn.mode():match('[vV]') and '<C-v>^o^I' or 'I' end,
    { expr = true, desc = 'Nice block I' }
  )
  vim.keymap.set(
    'v',
    'A',
    function() return vim.fn.mode():match('[vV]') and '<C-v>1o$A' or 'A' end,
    { expr = true, desc = 'Nice block A' }
  )

  -- Line movement with marker
  -- for _, c in ipairs({ { 'k', 'Line up' }, { 'j', 'Line down' } }) do
  --   vim.keymap.set(
  --     'n',
  --     c[1],
  --     ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
  --     { expr = true, silent = true, desc = c[2] }
  --   )
  -- end

  vim.keymap.set('n', '<space>k', '<Cmd>lua config.run_shell()<CR>', { desc = 'Run shell command in vsplit' })
  vim.keymap.set('n', '<space>K', '<Cmd>lua config.run_vim()<CR>', { desc = 'Run vim command in vsplit' })

  local mc_select = [[<esc>/\V\C<C-r>=luaeval("config.get_visual_selection()")<CR><CR>]]
  local mc_macro = function(selection)
    selection = selection or ''

    return function()
      if vim.fn.reg_recording() == 'z' then return 'q' end

      if vim.fn.getreg('z') ~= '' then return 'n@z' end

      return selection .. '*Nqz'
    end
  end

  vim.keymap.set('n', '<F7>', '*Nqz', { desc = 'mc start macro' })
  vim.keymap.set('n', '<F8>', mc_macro(), { desc = 'mc end or replay macro', expr = true })
  vim.keymap.set('x', '<F7>', mc_select .. '``qz', { desc = 'mc start macro' })
  vim.keymap.set('x', '<F8>', mc_macro(mc_select), { desc = 'mc end or replay macro', expr = true })

  local delimiter_chars = { ',', ';', '.' }

  -- Toggle or replace end-of-line delimiter characters.
  -- Example:
  -- - If the line ends with `;`, pressing `d;` will remove it.
  -- - If it ends with a different delimiter (e.g., `,`), `d;` will replace it with `;`.
  -- - If it ends with no delimiter, `d;` will append `;` at the end.
  for _, char in ipairs(delimiter_chars) do
    vim.keymap.set('n', 'd' .. char, function()
      local line = vim.api.nvim_get_current_line()
      local last = line:sub(-1)
      local new = line

      if last == char then
        new = line:sub(1, -2)
      elseif vim.tbl_contains(delimiter_chars, last) then
        new = line:sub(1, -2) .. char
      else
        new = line .. char
      end

      vim.api.nvim_set_current_line(new)
    end, {})
  end
end

--------------------------------------------------------------------------------
-- Custom
vim.api.nvim_create_autocmd('UIEnter', {
  group = 'UserCmds',
  desc = 'Setup Keymaps on UIEnter Event ',
  once = true,
  callback = vim.schedule_wrap(function() keymap.custom() end),
})

--------------------------------------------------------------------------------
