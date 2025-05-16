-------------------------------------------------------------------------------
-- Helper =====================================================================
-------------------------------------------------------------------------------
local H = {
  keymaps = {
    disabled = { 'q', 's', '<c-z>', '<space>' }, -- disable these entirely
    blackhole = { 'c', 'x', '<s-s>', '<s-d>', '<s-c>' }, -- map to '_ delete
    delimiter = { prefix = 'd', keys = { ',', ';', '.' } },
  },
}

-- Create a smart keymap wrapper using metatables
local keymap = {}

-- Valid vim modes
local valid_modes = { n = true, i = true, v = true, x = true, s = true, o = true, c = true, t = true }

-- Store mode combinations we've created
local mode_cache = {}

-- Function that performs the actual mapping
local function perform_mapping(modes, lhs, rhs, opts)
  opts = opts or {}
  local mapset = vim.keymap.set

  if type(lhs) == 'table' then
    -- Handle table of mappings
    for key, action in pairs(lhs) do
      mapset(modes, key, action, opts)
    end
  else
    -- Handle single mapping
    mapset(modes, lhs, rhs, opts)
  end

  return keymap -- Return keymap for chaining
end

-- Parse a mode string into an array of mode characters
local function parse_modes(mode_str)
  local modes = {}
  for i = 1, #mode_str do
    local char = mode_str:sub(i, i)
    if valid_modes[char] then table.insert(modes, char) end
  end
  return modes
end

-- Create the metatable that powers the dynamic mode access
local mt = {
  __index = function(_, key)
    -- If this mode combination is already cached, return it
    if mode_cache[key] then return mode_cache[key] end

    -- Check if this is a valid mode string
    local modes = parse_modes(key)
    if #modes > 0 then
      -- Create and cache a function for this mode combination
      local mode_fn = function(lhs, rhs, opts)
        opts = opts or { silent = true }
        local mapset = vim.keymap.set

        if type(lhs) == 'table' then
          opts = rhs or { silent = true }
          -- Handle table of mappings
          for key, action in pairs(lhs) do
            mapset(modes, key, action, opts)
          end
        else
          -- Handle single mapping
          mapset(modes, lhs, rhs, opts)
        end

        return keymap -- Return keymap for chaining
      end

      mode_cache[key] = mode_fn
      return mode_fn
    end

    return nil -- Not a valid mode key
  end,

  -- Make the keymap table directly callable
  __call = function(_, modes, lhs, rhs, opts)
    if type(modes) == 'string' then
      -- Convert string to mode list
      return perform_mapping(parse_modes(modes), lhs, rhs, opts)
    else
      -- Assume modes is already a list
      return perform_mapping(modes, lhs, rhs, opts)
    end
  end,
}

local map = setmetatable(keymap, mt)

-- Helper function for command mappings
local cmd = function(command) return '<cmd>' .. command .. '<CR>' end

-- Get visual selection text.
-- taken from: https://github.com/ibhagwan/nvim-lua/blob/f772c7b41ac4da6208d8ae233e1c471397833d64/lua/utils.lua#L96
H.get_visual_selection = function(nl_literal)
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '' then
    _, csrow, cscol, _ = unpack(vim.fn.getpos('.'))
    _, cerow, cecol, _ = unpack(vim.fn.getpos('v'))
    if mode == 'V' then
      cscol, cecol = 0, 999
    end
  else
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end

  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end

  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  local lines = vim.fn.getline(csrow, cerow)
  local n = #lines

  if n <= 0 then return '' end

  if n > 1 then return nil end

  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)

  return table.concat(lines, nl_literal and '\\n' or '\n')
end

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

-- double escaping is required due to interpretation by feedkeys and then search/replace
H.double_escape = function(str) return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters) end

-- Helper substitute visual mode
H.visual_charwise_selection = function()
  local visual_selection = H.get_visual_selection()

  if visual_selection == nil then
    print('search-replace does not support visual-blockwise selections')
    return
  end

  local backspace_keypresses = string.rep('\\<backspace>', 5)
  local left_keypresses = string.rep('\\<Left>', 2)

  vim.cmd(
    ':call feedkeys(":'
      .. backspace_keypresses
      .. '%s/'
      .. H.double_escape(visual_selection)
      .. '/'
      .. H.double_escape(visual_selection)
      .. '/'
      .. 'g'
      .. left_keypresses
      .. '")'
  )
end

H.safe_for_each = function(list, fn)
  if type(list) == 'table' and #list > 0 then
    for _, v in ipairs(list) do
      fn(v)
    end
  end
end

H.modify_line_end_delimiter = function(character)
  return function()
    local line = vim.api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(C.keymaps.delimiter.keys, last_char) then
      vim.api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      vim.api.nvim_set_current_line(line .. character)
    end
  end
end

-------------------------------------------------------------------------------
-- Keymaps ====================================================================
-------------------------------------------------------------------------------

-- ( Keymaps: Multiple Cursors )
-------------------------------------------------------------------------------
-- see: http://www.kevinli.co/p<space>pnosts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript
local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
local function mc_macro(selection)
  selection = selection or ''

  return function()
    if vim.fn.reg_recording() == 'z' then return 'q' end

    if vim.fn.getreg('z') ~= '' then return 'n@z' end

    return selection .. '*Nqz'
  end
end

map.n('<F7>', [[*Nqz]], { desc = 'mc start macro (foward)' })
map.n('<F8>', mc_macro(), { desc = 'mc end or replay macro', expr = true })
map.x('<F7>', mc_select .. '``qz', { desc = 'mc start macro (foward)' })
map.x('<F8>', mc_macro(mc_select), { desc = 'mc end or replay macro', expr = true })

-- ( Keymaps: Subtitute )
-------------------------------------------------------------------------------
local function left(count) return string.rep('<left>', count) end

local pattern = {
  selection = H.visual_charwise_selection,
  cword = ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI' .. left(3),
  vcword = ":'<,'>s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI" .. left(3),
  cWord = ':%s/\\V<C-r><C-a>/<C-r><C-a>/gI' .. left(3),
  buffer = ':%s/\\v//gI' .. left(4),
  visual = ':s/\\v//gI' .. left(4),
}
-- Search replace

map.n('<C-G><C-F>', pattern.cword, { silent = false, desc = ':%s/<cword>/<cword>/gI' })
map.n('<C-G><C-A>', pattern.cWord, { silent = false, desc = ':%s/<cWORD>/<cWORD>/gI' })
map.n('<C-G><C-S>', pattern.buffer, { silent = false, desc = ':%s/\\v../../gI' })

map.n('<C-G><C-B>', pattern.vcword, { silent = false, desc = ":'<, '>s/<cword>/<cword>/gI" })
map.x('<C-G><C-S>', pattern.visual, { silent = false, desc = ':s/\\v ../../gI' })
map.x('<C-G><C-F>', pattern.selection, { silent = false, desc = ':%s/<selection>/<selection>/gI' })

-- Global Search Replace Quickfix
-- * `:cdo` = "run every line in Quickfix"  | :cdo %s/foo/bar/g  | update
-- * `:cfdo` = "run every file in Quickfix" | :cfdo %s/foo/bar/g | update

-- Alternate cgn for easy press
map.n('<bs>', '*N"_cgn', { desc = 'cgn' })

-- ( Keymaps: Basic )
-------------------------------------------------------------------------------
-- Disable key
H.safe_for_each(H.keymaps.disabled, function(key) map.nvo(key, '<Nop>') end)

-- Blackhole key (delete without save to register)
H.safe_for_each(H.keymaps.blackhole, function(key) map.nvo(key, '"_' .. key) end)

-- delimiters
H.safe_for_each(
  H.keymaps.delimiter.keys,
  function(key) map.n(H.keymaps.delimiter.prefix .. key, H.modify_line_end_delimiter(key)) end
)

local smart_dd = function() return (vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd') end

-- Very helpful
map.n({
  ['dd'] = smart_dd,
  ['J'] = [['mz' . v:count1 . 'J`z']],
}, { expr = true })
map.nvo({
  ['0'] = [[:]],
  ['<C-H>'] = [[^]],
  ['<C-L>'] = [[g_]],
  ['<C-Z>'] = [[%]],
}, { remap = true })
map.x({
  ['>'] = [[>gv]],
  ['<'] = [[<gv]],
  -- Move selected lines up/down in visual Mode
  -- ['K'] = [[:move '<-2<CR>gv=gv]],
  -- ['J'] = [[:move '>+1<CR>gv=gv]],
})
map.x({
  ['I'] = function() return vim.fn.mode():match('[vV]') and '<C-v>^o^I' or 'I' end,
  ['A'] = function() return vim.fn.mode():match('[vV]') and '<C-v>1o$A' or 'A' end,
}, { expr = true })
map.c({
  ['<F1>'] = [[\(.*\)<Left><Left>]],
  ['<c-v>'] = [[<C-R>"]],
  ['<a-v>'] = [[<C-R>+]],
}, { silent = false })
map.t({
  ['<c-\\>'] = [[<C-\><C-n>]],
  ['<a-r>'] = [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
})

-- Buffer
map.n({
  ['<a-x>'] = cmd('bd'),
  ['<a-X>'] = cmd('bw'),
  ['<s-h>'] = cmd("lua MiniBracketed.buffer('backward')"),
  ['<s-l>'] = cmd("lua MiniBracketed.buffer('forward')"),
  ['<c-s-h>'] = cmd("lua MiniBracketed.buffer('first')"),
  ['<c-s-l>'] = cmd("lua MiniBracketed.buffer('last')"),
})
map.t({
  ['<a-x>'] = cmd('bw!'),
})

-- Transform case
map.n({
  ['cl'] = [[mzguiw`z]],
  ['ct'] = [[mzguiwgUl`z]],
  ['cu'] = [[mzgUiw`z]],
})

-- Keep matches center screen when cycling with n|N
map.n({
  ['n'] = [[nzzzv]],
  ['N'] = [[nzzzv]],
  ['<C-d>'] = [[<C-d>zz]],
  ['<C-u>'] = [[<C-u>zz]],
})

-- Move by visible lines
map.nvo({
  ['j'] = [[v:count == 0 ? 'gj' : 'j']],
  ['k'] = [[v:count == 0 ? 'gk' : 'k']],
}, { expr = true })

-- Newline without insert mode
map.n({
  ['<space>o'] = [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
  ['<space>O'] = [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
}, { desc = 'Newline without insert mode' })

-- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
map.n('<space>w', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })

-- Copy/paste with system clipboard
map.n({
  ['<space>y'] = [["+y]],
  ['<space>p'] = [["+p]],
})
map.x({
  ['<space>y'] = [["+y]],
  ['<space>p'] = [["+P]], -- Paste in Visual with `P` to not copy selected text (`:h v_P`)
})

map.x('p', 'P', { desc = 'Paste in Visual with `P` to not copy selected text' })

-- Reselect latest changed, put, or yanked text
map.n(
  'gV',
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = 'Visually select changed text' }
)

-- Search inside visual selection
map.x('g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

-- ( Keymaps Window )
-------------------------------------------------------------------------------
-- Window navigation
map.n({
  ['<a-w>'] = [[<C-w>w]],
})

map.t({
  ['<a-w>'] = [[<C-\><C-n><C-w>w]],
})

-- Window resize
map.n({
  ['<C-Up>'] = '<C-w>+',
  ['<C-Down>'] = '<C-w>-',
  ['<C-Left>'] = '<C-w><',
  ['<C-Right>'] = '<C-w>>',
})

-- ( Keymaps Readline )
-------------------------------------------------------------------------------
map.i('<C-A>', '<C-O>^')
map.c('<C-A>', '<Home>', { silent = false })

map.i('<C-B>', function()
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')
  if line:match('^%s*$') and col > #line then
    return '0<C-D><Esc>kJs'
  else
    return '<Left>'
  end
end, { expr = true })

map.c('<C-B>', '<Left>', { silent = false })

map.i('<C-D>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len then
    return '<C-D>'
  else
    return '<Del>'
  end
end, { expr = true })

map.c('<C-D>', function()
  local pos = vim.fn.getcmdpos()
  local len = #vim.fn.getcmdline()
  if pos > len then
    return '<C-D>'
  else
    return '<Del>'
  end
end, { expr = true, silent = false })

map.i('<C-E>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len or vim.fn.pumvisible() == 1 then
    return '<C-E>'
  else
    return '<End>'
  end
end, { expr = true })

map.i('<C-F>', function()
  local col = vim.fn.col('.')
  local len = #vim.fn.getline('.')
  if col > len then
    return '<C-F>'
  else
    return '<Right>'
  end
end, { expr = true })

map.c('<C-F>', function()
  local pos = vim.fn.getcmdpos()
  local len = #vim.fn.getcmdline()
  if pos > len then
    return vim.o.cedit
  else
    return '<Right>'
  end
end, { expr = true, silent = false })

-------------------------------------------------------------------------------
-- Quickfix ===================================================================
-------------------------------------------------------------------------------
local find_qf = function(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == 'l' and win['loclist'] == 1 then found = true end
    -- loclist window has 'quickfix' set, eliminate those
    if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0 then found = true end
    if found then table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] }) end
  end
  return win_tbl
end

-- open quickfix if not empty
local open_qf = function()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd('copen')
    vim.cmd('wincmd J')
  else
    print(string.format('%s is empty.', qf_name))
  end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
local open_loclist_all = function()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win['quickfix'] == 0 then
      if not qf_empty(win['winnr']) then
        -- switch active window before ':lopen'
        vim.api.nvim_set_current_win(win['winid'])
        vim.cmd('lopen')
      else
        print(string.format('%s is empty.', qf_name))
      end
    end
  end
end

-- toggle quickfix/loclist on/off
-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
H.toggle_qf = function(type)
  local windows = find_qf(type)
  if #windows > 0 then
    -- hide all visible windows
    for _, win in ipairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    -- no windows are visible, attempt to open
    if type == 'l' then
      open_loclist_all()
    else
      open_qf()
    end
  end
end

map.n('<space>q', function() H.toggle_qf('q') end, { desc = 'Toggle QF' })
map.n('<space>Q', function() H.toggle_qf('l') end, { desc = 'Toggle LL' })

-------------------------------------------------------------------------------
-- Toggle Options =============================================================
-------------------------------------------------------------------------------
local toggle_options = {
  'cursorline',
  'cursorcolumn',
  'hlsearch',
  'ignorecase',
  'list',
  'number',
  'relativenumber',
  'spell',
  'wrap',
}

local function toggle_option(option) vim.cmd(string.format('setlocal %s! %s?', option, option)) end

local function show_toggle_menu()
  vim.ui.select(toggle_options, {
    prompt = 'Toggle option:',
    format_item = function(item) return "Toggle '" .. item .. "'" end,
  }, function(choice)
    if choice then toggle_option(choice) end
  end)
end

map.n('<space>t', show_toggle_menu, { desc = 'Toggle UI option' })

-- ( MiniAi, MiniOperator , MiniSurround )
-------------------------------------------------------------------------------
map.xo({
  ['q'] = [[iq]],
  ['Q'] = [[aq]],
  ['w'] = [[iw]],
  ['W'] = [[iW]],
  ['t'] = [[it]],
  ['T'] = [[at]],
}, { remap = true })
map.n({
  ['X'] = [[gxiw]],
  ['M'] = [[gmm]],
  ['S'] = [[ysiw]],
}, { remap = true })

-- ( Other )
-------------------------------------------------------------------------------
map.n({
  ['<space>`'] = function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end,
  ['<space>x'] = cmd('lua MiniBufremove.delete()'),
  ['<space>X'] = cmd('lua MiniBufremove.wipeout()'),
  ['<space>%'] = cmd('lua Config.set_cwd()'),
  ['<space>-'] = cmd('lua Config.insert_section()'),
})

-- ( MiniSessions )
-------------------------------------------------------------------------------
map('n', '<space>ss', function()
  vim.cmd('wa')
  require('mini.sessions').write()
  require('mini.sessions').select()
end, { desc = 'Switch Session' })

map('n', '<space>sw', function()
  local cwd = vim.fn.getcwd()
  local last_folder = cwd:match('([^/]+)$')
  require('mini.sessions').write(last_folder)
end, { desc = 'Save Session' })

map('n', '<space>sf', function()
  vim.cmd('wa')
  require('mini.sessions').select()
end, { desc = 'Load Session' })
-- ( Keymaps: Oil )
-------------------------------------------------------------------------------
map.n({
  ['-'] = cmd('Oil'),
})

-- ( Keymaps: FzfLua )
-------------------------------------------------------------------------------
map.i({
  ['<c-x><c-f>'] = cmd('lua FzfLua.complete_path()'),
  ['<c-x><c-l>'] = cmd('lua FzfLua.complete_line()'),
})
map.x({
  ['sk'] = cmd('lua FzfLua.grep_visual()'),
})
map.n({
  ['<c-b>'] = cmd('lua FzfLua.buffers()'),
  ['<c-]>'] = cmd('lua FzfLua.builtin()'),
  ['s0'] = cmd('lua FzfLua.command_history()'),
  ['sf'] = cmd('lua FzfLua.git_files()'),
  ['sh'] = cmd('lua FzfLua.search_history()'),
  ['si'] = cmd('lua FzfLua.grep()'),
  ['sj'] = cmd('lua FzfLua.lgrep_curbuf()'),
  ['sk'] = cmd('lua FzfLua.grep_cword()'),
  ['sl'] = cmd('lua FzfLua.lsp()'),
  ['sm'] = cmd('lua FzfLua.bookmark()'),
  ['sn'] = cmd('lua FzfLua.snippets()'),
  ['so'] = cmd('lua FzfLua.mru()'),
  ['sp'] = cmd('lua FzfLua.files()'),
  ['sr'] = cmd('lua FzfLua.live_grep_resume()'),
  ['ss'] = cmd('lua FzfLua.resume()'),
  ['z='] = cmd('lua FzfLua.spell_suggest()'),
})

-- ( Keymaps: Git )
-------------------------------------------------------------------------------
map.n({
  ['<space>go'] = cmd('lua MiniDiff.toggle_overlay()'),
  ['<space>ga'] = cmd('Gwrite'),
  ['<space>gr'] = cmd('Gread'),
  ['<space>gd'] = cmd('Gvdiffsplit'),
  ['<Space>gd'] = cmd('Gdiff'),
  ['<Space>gD'] = cmd('Git diff'),
  ['<Space>gB'] = cmd('Git blame'),
  ['<Space>gl'] = cmd('Git log --oneline --follow -- %'),
  ['<Space>gL'] = cmd('Git log --oneline --graph'),
})

map.n({
  ['<F4>'] = cmd('Zenmode'),
  ['<F5>'] = cmd('vert Git'),
})

map.tn('<F3>', function()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  vim.fn.jobstart('gitui', {
    term = true,
    on_exit = function()
      vim.cmd('silent! checktime')
      vim.cmd('silent! bw')
    end,
  })

  vim.cmd('startinsert')
end)
