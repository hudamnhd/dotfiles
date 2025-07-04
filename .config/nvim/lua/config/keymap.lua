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
  vim.keymap.set('', 's', '<nop>')
  vim.keymap.set('', '<space>', '<nop>')

  -- Save / Quit
  vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save current buffer' })
  vim.keymap.set('n', '<leader>q', '<cmd>bd<cr>', { desc = 'Delete current buffer' })

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

  -- Redo
  vim.keymap.set('n', 'U', '<C-r>', { noremap = true })

  -- Jump to match bracket
  vim.keymap.set({ 'n', 'v' }, '<C-z>', '%')
  vim.keymap.set('i', '<C-z>', '<C-o>%')

  -- Toggle zoom
  vim.keymap.set('n', '|', '<cmd>Zoom<cr>')

  -- Messages
  vim.keymap.set('n', '<leader>m', '<cmd>messages<cr>', { desc = 'Show messages' })
  vim.keymap.set('n', '<leader>M', '<cmd>messages clear<cr>', { desc = 'Clear messages' })

  -- File Explorer
  vim.keymap.set('n', '<leader>e', '<cmd>Ex<cr>', { desc = 'Open netrw' })

  -- Search file (manual)
  vim.keymap.set('n', '<leader>f', ':find ', { silent = false, desc = 'Search file' })

  -- === TEXT MANIPULATION ===

  -- Indent keep selection
  vim.keymap.set('v', '<', '<gv', {})
  vim.keymap.set('v', '>', '>gv', {})

  -- Move lines up/down
  vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv=gv", {})
  vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv=gv", {})

  -- Keep center on search
  vim.keymap.set('n', 'n', 'nzzzv', { desc = "Fwd search '/' or '?'" })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Back search '/' or '?'" })

  -- Join line with cursor stay
  vim.keymap.set('n', 'J', [['mz' . v:count1 . 'J`z']], { expr = true, desc = 'Join lines keep cursor' })

  -- Undo breakpoints
  vim.keymap.set('i', ',', ',<C-g>u')
  vim.keymap.set('i', '.', '.<C-g>u')
  vim.keymap.set('i', ';', ';<C-g>u')

  -- Change word with search
  vim.keymap.set('n', '<Bs>', '*N"_cgn')

  -- Select last pasted/yanked
  vim.keymap.set('n', 'g<C-v>', '`[v`]', { desc = 'Visual select last yank/paste' })

  -- === CASE CONVERSION ===

  vim.keymap.set('n', 'cl', 'mzguiw`z', { desc = 'To lowercase' })
  vim.keymap.set('n', 'ct', 'mzguiwgUl`z', { desc = 'To titlecase' })
  vim.keymap.set('n', 'cu', 'mzgUiw`z', { desc = 'To uppercase' })

  -- === CLIPBOARD / BLACKHOLE ===

  -- Cut to blackhole
  vim.keymap.set({ 'n', 'x' }, 'D', '"_D')
  vim.keymap.set({ 'n', 'x' }, 'c', '"_c')
  vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
  vim.keymap.set('n', 'd', '"_d')

  -- Paste without overwrite
  vim.keymap.set('x', 'p', [['pgv"' . v:register . 'y']], { expr = true, noremap = true, desc = 'Paste keep reg' })

  -- Clipboard
  vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
  vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste from clipboard' })

  -- === PICKER NAVIGATION ===

  vim.keymap.set('n', '<leader>vb', ':ls<cr>:buffer ', { desc = 'Picker buffer' })
  vim.keymap.set('n', '<leader>vu', ':undolist<cr>:undo ', { desc = 'Picker undolist' })
  vim.keymap.set('n', '<leader>vw', ':g/<C-r><C-w>/#<cr>:', { desc = 'Picker g' })
  vim.keymap.set('n', '<leader>vg', ':changes<cr>:normal! g;<S-Left>', { desc = 'Picker changes' })
  vim.keymap.set('n', '<leader>vm', ':marks<cr>:normal! `', { desc = 'Picker mark' })
  vim.keymap.set('n', '<leader>vo', ':oldfiles<cr>:edit #<', { desc = 'Picker oldfiles' })
  vim.keymap.set('n', '<leader>vr', ':registers<cr>:normal! "p<left>', { desc = 'Picker register' })
  vim.keymap.set('n', '<leader>vj', ':jumps<cr>:normal!<C-O><S-Left>', { desc = 'Picker jumps' })

  -- Quickfix / Location list
  vim.keymap.set('n', '<leader>xq', "<cmd>lua config.toggle_qf('q')<cr>", { desc = 'Quickfix List' })
  vim.keymap.set('n', '<leader>xl', "<cmd>lua config.toggle_qf('l')<cr>", { desc = 'Location List' })

  -- === SUBSTITUTE ===

  vim.keymap.set('n', '<leader>sl', ':%s///gI<left><left><left>', { silent = false, desc = 'Sub last search' })
  vim.keymap.set(
    'n',
    '<leader>su',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { silent = false, desc = 'Sub word under cursor' }
  )
  vim.keymap.set(
    'x',
    '<leader>su',
    [[:<C-u>%s/\V<C-r>=luaeval("config.get_visual_selection()")<cr>/<C-r>=luaeval("config.get_visual_selection()")<cr>/gI<Left><Left><Left>]],
    { silent = false, desc = 'Sub visual selection' }
  )

  -- Search in visual selection
  vim.keymap.set('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual' })

  -- === USEFUL ===

  -- Floating terminal toggle
  vim.keymap.set({ 'n', 't' }, '<C-t>', '<cmd>lua config.toggle_floating_term()<cr>')

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
  for _, c in ipairs({ { 'k', 'Line up' }, { 'j', 'Line down' } }) do
    vim.keymap.set(
      'n',
      c[1],
      ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
      { expr = true, silent = true, desc = c[2] }
    )
  end

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
--- Readline
function keymap.readline()
  vim.keymap.set('i', '<C-a>', '<C-o>^', { desc = 'move to end of first non-whitespace character in line' })
  vim.keymap.set('c', '<C-a>', '<Home>', { silent = false, desc = 'move cursor to start of command line' })
  vim.keymap.set('i', '<C-b>', function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    if line:match('^%s*$') and col > #line then
      return '0<C-D><Esc>kJs'
    else
      return '<Left>'
    end
  end, { expr = true, desc = 'move cursor left or handle empty line' })
  vim.keymap.set('c', '<C-b>', '<left>', { silent = false, desc = 'move cursor one position left in command line' })
  vim.keymap.set('i', '<C-d>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-d>'
    else
      return '<Del>'
    end
  end, { expr = true, desc = 'delete character or handle end of line in insert mode' })
  vim.keymap.set('c', '<C-d>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return '<C-d>'
    else
      return '<Del>'
    end
  end, { expr = true, silent = false, desc = 'delete in command line depending on cursor position' })
  vim.keymap.set('i', '<C-e>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len or vim.fn.pumvisible() == 1 then
      return '<C-e>'
    else
      return '<End>'
    end
  end, { expr = true, desc = 'move to end of line or show completion menu' })
  vim.keymap.set('i', '<C-f>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-f>'
    else
      return '<Right>'
    end
  end, { expr = true, desc = 'move cursor right or handle end of line' })
  vim.keymap.set('c', '<C-f>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return vim.o.cedit
    else
      return '<Right>'
    end
  end, {
    expr = true,
    silent = false,
    desc = 'move cursor right in command line depending on position',
  })
end

-- Custom
vim.api.nvim_create_autocmd('UIEnter', {
  group = 'UserCmds',
  desc = 'Setup Keymaps on UIEnter Event ',
  once = true,
  callback = vim.schedule_wrap(function() keymap.custom() end),
})

-- Readline
vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
  group = 'UserCmds',
  desc = 'Readline setup',
  once = true,
  callback = vim.schedule_wrap(function() keymap.readline() end),
})
--------------------------------------------------------------------------------
