local M = {}
--------------------------------------------------------------------------------
--- Entry point
--------------------------------------------------------------------------------
-- See :help lua-guide
M.load_options = true
M.load_autocmds = true
M.load_keymaps = true
M.load_plugins = true

--------------------------------------------------------------------------------
--- Options
--------------------------------------------------------------------------------
-- See :help vim.o
-- See :help vim.opt
local load_options = function()
  -- Visual
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.wrap = false
  vim.o.signcolumn = 'yes:1' -- Show sign column as first column
  vim.o.title = true
  vim.o.titlelen = 45
  vim.o.titlestring = 'nvim: %F'
  vim.o.confirm = true -- confirm before loss of data with `:q`
  vim.o.showmode = false
  vim.o.splitkeep = 'screen'
  vim.o.list = true
  vim.o.laststatus = 3
  vim.opt.listchars = { tab = '▏ ', trail = '·', extends = '»', precedes = '«' }

  -- Editing
  vim.o.mouse = '' -- disable the mouse
  vim.o.textwidth = 80 -- max inserted text width for paste operations
  vim.o.breakindent = true -- start wrapped lines indented
  vim.o.linebreak = true -- do not break words on line wrap
  vim.o.splitbelow = true -- ':new' ':split' below current
  vim.o.splitright = true -- ':vnew' ':vsplit' right of current
  vim.o.scrolloff = 3 -- min number of lines to keep between cursor and screen edge
  vim.o.sidescrolloff = 5 -- min number of cols to keep between cursor and screen edge
  vim.o.switchbuf = 'useopen,uselast' -- jump to already open buffers on `:cn|:cp`

  -- Indentation
  vim.o.expandtab = true -- Convert all tabs that are typed into spaces
  vim.o.joinspaces = true -- insert spaces after '.?!' when joining lines
  vim.o.smartindent = true -- add <tab> depending on syntax (C/C++)
  vim.o.tabstop = 2 -- Tab indentation levels every two columns
  vim.o.shiftwidth = 0 -- Use `tabstop` value for auto-indent
  vim.o.shiftround = true -- Always indent/outdent to nearest tabstop

  -- Update times and timeouts.
  vim.o.updatetime = 300
  vim.o.timeoutlen = 500
  vim.o.ttimeoutlen = 10

  -- Search
  vim.o.hlsearch = false
  vim.o.ignorecase = false -- ignore case on search
  vim.o.smartcase = false -- case sensitive when search includes uppercase

  -- Buffers
  vim.o.hidden = true -- do not unload buffer when abandoned
  vim.o.writebackup = false -- do not backup file before write
  vim.o.swapfile = false -- no swap file
  vim.o.undofile = true -- Enable persistent undo
  vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undodir'

  -- recursive :find in current dir
  vim.cmd([[set path=.,,,$PWD/**]])

  -- Enable all filetype plugins
  vim.cmd('filetype plugin indent on')
end
--------------------------------------------------------------------------------
--- Keymaps
--------------------------------------------------------------------------------
-- Set global and local Leader keys to space
-- See :help vim.g:help vim.g
vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')

-- Swap ; :
vim.keymap.set('', ';', ':', { noremap = true })
vim.keymap.set('', ':', ';', { noremap = true })

local disabled_keys = { 's', 'q', '<C-z>', '<Space>' }
local blackhole_keys = { 'x', 'c', 'd' }
local undo_break_chars = { ',', ';', '.' }
local delimiter_chars = { ',', ';', '.' }

local define_keymaps = function(actions)
  -- See :help <Nop>
  for _, char in ipairs(disabled_keys) do
    M.map('nv', char, '<Nop>')
  end
  -- See :help quote_
  for _, char in ipairs(blackhole_keys) do
    M.map(char ~= 'd' and 'nv' or 'n', char, '"_' .. char)
  end
  -- undo break chars
  for _, char in ipairs(undo_break_chars) do
    M.map('i', char, char .. '<C-g>u')
  end

  --stylua: ignore
  M.keymaps({
    -- Insert / Change / Delete
    { 'i',     actions.smart_insert, { expr = true } },
    { 'cl',    actions.to_lowercase },
    { 'ct',    actions.to_titlecase },
    { 'cu',    actions.to_uppercase },
    { 'd<Bs>', actions.delete_with_repeat },
    { 'c<Bs>', actions.change_with_repeat },

    -- Search & Substitute
    { 'n',      actions.search_next_normal, { expr = true } },
    { 'N',      actions.search_prev_normal, { expr = true } },
    { 'g<C-s>', actions.substitute_search,  { silent = false, desc = 'Substitute latest search' } },
    { 'g<C-b>', actions.substitute_cword,   { silent = false, desc = 'Substitute cword' } },
    { 'g<C-b>', actions.substitute_visual,  { silent = false, desc = 'Substitute visual', mode = 'x' } },

    -- Paste & Yank
    { 'p',      actions.paste_keep_register,  { mode = 'x',  expr = true } },
    { 'gp',     actions.paste_from_clipboard, { mode = 'nx', desc = 'Paste from clipboard' } },
    { 'gy',     actions.yank_to_clipboard,    { mode = 'nx', desc = 'Yank to clipboard' } },
    { 'g<C-v>', actions.select_last_yank,     { desc = 'Select last yank/paste' } },

    -- Visual & Block
    { 'J', actions.join_with_keep_cursor, { mode = 'nx', expr = true } },
    { 'k', actions.move_line_up,          { mode = 'nx', expr = true } },
    { 'j', actions.move_line_down,        { mode = 'nx', expr = true } },
    { '<', actions.indent_left,           { mode = 'v' } },
    { '>', actions.indent_right,          { mode = 'v' } },
    { 'I', actions.nice_block_I,          { mode = 'v',  expr = true } },
    { 'A', actions.nice_block_A,          { mode = 'v',  expr = true } },

    -- Navigation & Brackets
    { '<C-z>', actions.match_bracket,   { mode = 'nv' } },
    { '<C-h>', actions.goto_line_start, { mode = 'nv' } },
    { '<C-l>', actions.goto_line_end,   { mode = 'nv' } },

    --  Rotate
    { '<A-w>', actions.rotate_view_normal },
    { '<A-w>', actions.rotate_view_terminal, { mode = 't' } },

    -- Terminal
    { '<A-r>',  actions.insert_register_term, { mode = 't', expr = true } },
    { '<C-\\>', actions.exit_terminal_mode,   { mode = 't' } },
    { '<C-t>',  actions.toggle_floating_term, { mode = 'nt' } },

    -- Command-line
    { '<F1>',  actions.regex_capture_all,        { mode = 'c', silent = false } },
    { '<F2>',  actions.regex_fuzzy_match,        { mode = 'c', silent = false } },
    { '<C-v>', actions.paste_register_default,   { mode = 'c', silent = false } },
    { '<A-v>', actions.paste_register_clipboard, { mode = 'c', silent = false } },

    { '<C-r><C-v>', actions.get_visual_selection, { mode = 'c', silent = false } },

    -- Leader
    { '<Leader>q',  actions.buffer_delete, { desc = 'Buffer delete' } },
    { '<Leader>m',  actions.show_messages, { desc = 'Show messages' } },
    { '<Leader>K',  actions.keywordprg,    { desc = 'Keywordprg' } },
    { '<Leader>w',  actions.save_file,     { desc = 'Save File' } },

    -- Quickfix List/Location List
    { '<leader>xq', actions.toggle_quickfix, { desc = 'Quickfix List' } },
    { '<leader>xl', actions.toggle_loclist,  { desc = 'Location List'  } },
  })
end

-- Setup Keymaps on UIEnter Event
local load_keymaps = function()
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    callback = vim.schedule_wrap(function()
      local actions = {
        -- Navigation
        match_bracket = '%',
        goto_line_start = '^',
        goto_line_end = 'g_',
        join_with_keep_cursor = function() return 'mz' .. vim.v.count1 .. 'J`z' end,
        move_line_down = [[v:count == 0 ? 'gj' : 'j']],
        move_line_up = [[v:count == 0 ? 'gk' : 'k']],

        -- Editing
        smart_delete_line = function() return (vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd') end,
        smart_insert = function() return vim.trim(vim.api.nvim_get_current_line()) == '' and '"_cc' or 'i' end,
        nice_block_I = function() return vim.fn.mode():match('[vV]') and '<C-v>^o^I' or 'I' end,
        nice_block_A = function() return vim.fn.mode():match('[vV]') and '<C-v>1o$A' or 'A' end,
        delete_with_repeat = '*N"_dgn',
        change_with_repeat = '*N"_cgn',

        -- Search
        search_next_normal = "'Nn'[v:searchforward].'zv'",
        search_prev_normal = "'nN'[v:searchforward].'zv'",

        -- Buffer
        buffer_delete = '<cmd>bd<cr>',

        -- System
        help_index = ':help index<cr>',
        help_cWORD = ':help <C-r><C-a><cr>',
        keywordprg = '<cmd>norm! K<cr>',
        show_messages = '<cmd>messages<cr>',
        save_file = '<cmd>write<cr>',

        -- Indent
        indent_left = '<gv',
        indent_right = '>gv',

        -- Register
        paste_keep_register = function() return 'pgv"' .. vim.v.register .. 'y' end,
        paste_from_clipboard = '"+p',
        yank_to_clipboard = '"+y',
        insert_register_term = function() return '<C-\\><C-n>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi' end,

        -- Win
        rotate_view_normal = '<C-w>w',
        rotate_view_terminal = [[<C-\><C-n><C-w>w]],
        exit_terminal_mode = [[<C-\><C-n>]],

        -- Cmdline
        paste_register_default = '<C-r>"',
        paste_register_clipboard = '<C-r>+',
        regex_capture_all = [[\(.*\)]],
        regex_fuzzy_match = [[.\{-}]],
        get_visual_selection = [[<c-r>=luaeval("get_visual_selection(false)")<cr>]],

        -- Yank Visual Select
        select_last_yank = '`[v`]',
        substitute_search = ':%s///gI<left><left><left>',
        substitute_cword = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        substitute_visual = [[:<C-u>%s/\V<C-r>=luaeval("get_visual_selection()")<cr>/<c-r>=luaeval("get_visual_selection()")<cr>/gI<Left><Left><Left>]],

        -- case
        to_lowercase = 'mzguiw`z',
        to_titlecase = 'mzguiwgUl`z',
        to_uppercase = 'mzgUiw`z',

        -- qf/ll
        toggle_quickfix = function() M.toggle_qf('q') end,
        toggle_loclist = function() M.toggle_qf('l') end,

        -- term
        toggle_floating_term = M.toggle_floating_term,
      }

      define_keymaps(actions)

      local function modify_line_end_delimiter(character)
        return function()
          local line = vim.api.nvim_get_current_line()
          local last_char = line:sub(-1)
          local set_line = vim.api.nvim_set_current_line
          if last_char == character then
            set_line(line:sub(1, #line - 1))
          elseif vim.tbl_contains(delimiter_chars, last_char) then
            set_line(line:sub(1, #line - 1) .. character)
          else
            set_line(line .. character)
          end
        end
      end

      for _, key in ipairs(delimiter_chars) do
        M.map('n', string.format('d%s', key), modify_line_end_delimiter(key), {})
      end
    end),
  })
end

--------------------------------------------------------------------------------
--- AUTOCMDS
--------------------------------------------------------------------------------
local load_autocmds = function()
  vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
    desc = 'Readline setup',
    once = true,
    callback = function()
      -- Readline Style Input
      vim.keymap.set('i', '<c-a>', '<c-o>^', { desc = 'move to end of first non-whitespace character in line' })
      vim.keymap.set('c', '<c-a>', '<home>', { silent = false, desc = 'move cursor to start of command line' })
      vim.keymap.set('i', '<c-b>', function()
        local line = vim.fn.getline('.')
        local col = vim.fn.col('.')
        if line:match('^%s*$') and col > #line then
          return '0<C-D><Esc>kJs'
        else
          return '<left>'
        end
      end, { expr = true, desc = 'move cursor left or handle empty line' })
      vim.keymap.set('c', '<c-b>', '<left>', { silent = false, desc = 'move cursor one position left in command line' })
      vim.keymap.set('i', '<c-d>', function()
        local col = vim.fn.col('.')
        local len = #vim.fn.getline('.')
        if col > len then
          return '<c-d>'
        else
          return '<del>'
        end
      end, { expr = true, desc = 'delete character or handle end of line in insert mode' })
      vim.keymap.set('c', '<c-d>', function()
        local pos = vim.fn.getcmdpos()
        local len = #vim.fn.getcmdline()
        if pos > len then
          return '<c-d>'
        else
          return '<del>'
        end
      end, { expr = true, silent = false, desc = 'delete in command line depending on cursor position' })
      vim.keymap.set('i', '<c-e>', function()
        local col = vim.fn.col('.')
        local len = #vim.fn.getline('.')
        if col > len or vim.fn.pumvisible() == 1 then
          return '<c-e>'
        else
          return '<end>'
        end
      end, { expr = true, desc = 'move to end of line or show completion menu' })
      vim.keymap.set('i', '<c-f>', function()
        local col = vim.fn.col('.')
        local len = #vim.fn.getline('.')
        if col > len then
          return '<c-f>'
        else
          return '<right>'
        end
      end, { expr = true, desc = 'move cursor right or handle end of line' })
      vim.keymap.set('c', '<c-f>', function()
        local pos = vim.fn.getcmdpos()
        local len = #vim.fn.getcmdline()
        if pos > len then
          return vim.o.cedit
        else
          return '<right>'
        end
      end, {
        expr = true,
        silent = false,
        desc = 'move cursor right in command line depending on position',
      })
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'qf', 'man', 'help', 'checkhealth' },
    desc = 'Close some filetypes with <q>',
    callback = function(event)
      local buftype = vim.bo.buftype

      --vsplit help
      if buftype == 'help' or buftype == 'nofile' then vim.cmd('wincmd L') end
      vim.bo[event.buf].buflisted = false

      --close q
      vim.schedule(function()
        vim.keymap.set('n', 'q', function()
          vim.cmd('close')
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end, {
          buffer = event.buf,
          silent = true,
          desc = 'Quit buffer',
        })
      end)
    end,
  })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlighted yank',
    callback = function() vim.hl.on_yank({ timeout = 100 }) end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Restore cursor position',
    callback = function(ctx)
      if vim.bo[ctx.buf].buftype ~= '' then return end
      vim.cmd([[silent! normal! g`"]])
    end,
  })

  vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    pattern = 'term://*',
    callback = vim.schedule_wrap(function(data)
      -- Try to start terminal mode only if target terminal is current
      if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
      vim.cmd('startinsert')
    end),
    desc = 'Auto insert current terminal',
  })

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
    callback = function(event)
      if event.match:match('^%w%w+:[\\/][\\/]') then return end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    desc = 'Check if we need to reload the file when it changed',
    callback = function()
      if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'FocusLost' }, {
    desc = 'Autosave on focus change',
    nested = true,
    callback = function(info)
      -- Don't auto-save non-file buffers
      if (vim.uv.fs_stat(info.file) or {}).type ~= 'file' then return end
      vim.cmd.update({
        mods = { emsg_silent = true },
      })
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Delete trailing whitespace',
    pattern = '*',
    command = [[%s/\s\+$//e]],
  })
end
--------------------------------------------------------------------------------
--- PLUGINS
--------------------------------------------------------------------------------
-- Register plugins
function M.plugins()
  -- See :help MiniDeps-plugin-specification
  return {
    -- Best plugin by Echasnovski that provides many modules
    -- https://github.com/echasnovski/mini.nvim
    {
      name = 'mini.nvim',
      checkout = 'HEAD',
      lazy = false,
      config = function()
        M.register_plugins({
          -- Text editing
          { module = 'mini.align' }, -- See :help MiniAlign-examples
          { module = 'mini.comment' },
          { module = 'mini.operators', opts = {
            sort = { prefix = 'gz' },
          } },
          {
            module = 'mini.ai',
            config = function()
              M.keymaps({
                { 'q', 'iq' },
                { 'Q', 'aq' },
                { 'w', 'iw' },
                { 'W', 'iW' },
              }, { mode = 'xo', remap = true })
            end,
          },
          {
            module = 'mini.pairs',
            --See :help MiniPairs.config
            opts = {
              mappings = {
                ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
                ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
              },
            },
          },
          {
            module = 'mini.surround',
            setup = false,
            config = function()
              --See :help MiniSurround-vim-surround-config
              require('mini.surround').setup({
                mappings = {
                  add = 'ys',
                  delete = 'ds',
                  find = '',
                  find_left = '',
                  highlight = '',
                  replace = 'cs',
                  update_n_lines = '',
                },
              })

              -- unmap config generated `ys` mapping, prevents visual mode yank delay
              if vim.keymap then
                vim.keymap.del('x', 'ys')
              else
                vim.cmd('xunmap ys')
              end

              -- Remap adding surrounding to Visual mode selection
              M.map('x', 's', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = 'Surround add visual' })
              M.map('n', 'yss', 'ys_', { remap = true })
            end,
          },
          { module = 'mini.move', opts = { options = { reindent_linewise = false } } },
          { module = 'mini.splitjoin', opts = { mappings = { toggle = 'gj' } } },

          -- General workflow
          { module = 'mini.bracketed' },
          --[[
          `Target`                           `Mappings`         `Lua function`
          --------------------------------------------------------------------------------
          Buffer.......................... `[B` `[b` `]b` `]B` .... |MiniBracketed.buffer()|
          Comment block................... `[C` `[c` `]c` `]C` .... |MiniBracketed.comment()|
          Conflict marker................. `[X` `[x` `]x` `]X` .... |MiniBracketed.conflict()|
          Diagnostic...................... `[D` `[d` `]d` `]D` .... |MiniBracketed.diagnostic()|
          File on disk.................... `[F` `[f` `]f` `]F` .... |MiniBracketed.file()|
          Indent change................... `[I` `[i` `]i` `]I` .... |MiniBracketed.indent()|

          Jump from |jumplist|
          inside current buffer........... `[J` `[j` `]j` `]J` .... |MiniBracketed.jump()|
          Location from |location-list|....`[L` `[l` `]l` `]L` .... |MiniBracketed.location()|
          Old files....................... `[O` `[o` `]o` `]O` .... |MiniBracketed.oldfile()|
          Quickfix entry from |Quickfix|...`[Q` `[q` `]q` `]Q` .... |MiniBracketed.quickfix()|
          Tree-sitter node and parents.... `[T` `[t` `]t` `]T` .... |MiniBracketed.treesitter()|

          Undo states from specially
          tracked linear history.......... `[U` `[u` `]u` `]U` .... |MiniBracketed.undo()|
          Window in current tab........... `[W` `[w` `]w` `]W` .... |MiniBracketed.window()|

          Yank selection replacing
          latest put region............... `[Y` `[y` `]y` `]Y` .... |MiniBracketed.yank()|
          --]]
          { module = 'mini.extra' },
          {
            module = 'mini.jump',
            opts = {
              mappings = {
                repeat_jump = ':',
              },
            },
          },
          {
            module = 'mini.sessions',
            lazy = false,
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

              M.keymaps({
                { '<Leader>zs', actions.switch_session, { desc = 'Switch Session' } },
                { '<Leader>zw', actions.write_session, { desc = 'Write Session' } },
                { '<Leader>zl', actions.load_session, { desc = 'Load Session' } },
                { '<Leader>zd', actions.delete_session, { desc = 'Delete Session' } },
              })
            end,
          },
          {
            module = 'mini.bufremove',
            config = function()
              M.map('n', '<Leader>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete buffer' })
              M.map('n', '<Leader>bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout buffer' })
            end,
          },
          {
            module = 'mini.files',
            opts = {
              mappings = {
                synchronize = '<Leader>w',
              },
              options = { permanent_delete = false },
            },
            -- See :help MiniFiles
            config = function()
              local MiniFiles = require('mini.files')

              M.map('n', '<Leader>e', function()
                local file = vim.api.nvim_buf_get_name(0)
                if vim.fn.filereadable(file) == 1 then
                  MiniFiles.open(file)
                else
                  MiniFiles.open()
                end
              end, { desc = 'Explorer' })

              -- # Create mappings to modify target window via split ~
              local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                  -- Make new window and set it as target
                  local cur_target = MiniFiles.get_explorer_state().target_window
                  local new_target = vim.api.nvim_win_call(cur_target, function()
                    vim.cmd(direction .. ' split')
                    return vim.api.nvim_get_current_win()
                  end)

                  MiniFiles.set_target_window(new_target)

                  -- This intentionally doesn't act on file under cursor in favor of
                  -- explicit "go in" action (`l` / `L`). To immediately open file,
                  -- add appropriate `MiniFiles.go_in()` call instead of this comment.
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = 'Split ' .. direction
                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
              end

              -- Set focused directory as current working directory
              local set_cwd = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.chdir(vim.fs.dirname(path))
              end

              -- Yank in register full path of entry under cursor
              local yank_path = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.setreg(vim.v.register, path)
              end

              -- Open path with system default handler (useful for non-text files)
              local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

              local set_mark = function(id, path, desc) MiniFiles.set_bookmark(id, path, { desc = desc }) end

              vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                  local b = args.data.buf_id
                  -- Tweak keys to your liking
                  map_split(b, '<C-s>', 'belowright horizontal')
                  map_split(b, '<C-v>', 'belowright vertical')
                  map_split(b, '<C-t>', 'tab')

                  set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
                  set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
                  set_mark('~', '~', 'Home directory')

                  M.keymaps({
                    { 'g~', set_cwd, { desc = 'Set cwd' } },
                    { 'gX', ui_open, { desc = 'OS open' } },
                    { 'gy', yank_path, { desc = 'Yank path' } },
                  }, { buffer = b })
                end,
              })
            end,
          },
          {
            module = 'mini.diff',
            -- See :help MiniDiff.config
            opts = {
              view = {
                style = 'sign',
                signs = { add = '+', change = '~', delete = '-' },
              },
            },
          },
          {
            module = 'mini.clue',
            setup = false,
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
                  delay = vim.o.timeoutlen,
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
          },

          -- Appearance
          {
            module = 'mini.starter',
            lazy = false,
            setup = false,
            config = function()
              local starter = require('mini.starter')
              -- See :help MiniStarter-example-config
              starter.sections.quick_access = function()
                return function()
                  return {
                    { action = 'lua MiniFiles.open()', name = 'Explorer', section = 'Quick Access' },
                    { action = 'FzfLua files', name = 'Files', section = 'Quick Access' },
                    { action = 'FzfLua grep', name = 'Grep', section = 'Quick Access' },
                    { action = 'FzfLua helptags', name = 'Help tags', section = 'Quick Access' },
                    { action = 'FzfLua oldfiles', name = 'Old files', section = 'Quick Access' },
                    { action = 'F ~/.config/nvim', name = 'Config', section = 'Quick Access' },
                  }
                end
              end

              starter.setup({
                items = {
                  starter.sections.quick_access(),
                  starter.sections.sessions(5, true),
                },
                -- taken from: https://github.com/MaximilianLloyd/ascii.nvim/blob/1f93678874d58b6e51465b31d0c1c90a7008fd42/lua/ascii/text/neovim.lua#L224
                header = [[
                                             
      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
    ]],
                content_hooks = {
                  starter.gen_hook.adding_bullet(),
                  starter.gen_hook.aligning('center', 'center'),
                },
              })
            end,
          },
          { module = 'mini.statusline' },
          {
            module = 'mini.tabline',
            setup = false,
            config = function()
              local function get_buf_index(buf_id)
                local bufs = vim.fn.getbufinfo({ buflisted = 1 })
                for i, id in ipairs(bufs) do
                  if id.bufnr == buf_id then return i end
                end
                return nil
              end

              local MiniTabline = require('mini.tabline')

              MiniTabline.setup({
                -- Whether to show file icons (requires 'mini.icons')
                show_icons = false,
                format = function(buf_id, label)
                  label = label == '*' and '[No Name]' or label
                  local buf_index = get_buf_index(buf_id) or ''
                  local suffix = vim.bo[buf_id].modified and '+ ' or ''
                  return MiniTabline.default_format(buf_id, buf_index .. ' ' .. label) .. suffix
                end,
                tabpage_section = 'left',
              })

              local keys = '123456789'
              for i = 1, #keys do
                local key = keys:sub(i, i)
                local key_combination = string.format('<space>%s', key)
                M.map('n', key_combination, function()
                  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
                  local target = buffers[i]
                  if target then
                    vim.api.nvim_set_current_buf(target.bufnr)
                  else
                    vim.notify('Buffer #' .. i .. ' not found', vim.log.levels.WARN)
                  end
                end, { desc = 'Goto buffer ' .. i })
              end
            end,
          },
          { module = 'mini.icons' },
          { module = 'mini.indentscope' },
          { module = 'mini.colors' },
          {
            module = 'mini.notify',
            setup = false,
            config = function()
              -- taken from: https://github.com/echasnovski/nvim/blob/5f170054662940d5e2f8badbe816996a8ec744dd/plugin/20_mini.lua#L35
              local notify = require('mini.notify')
              local predicate = function(notif)
                if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
                -- Filter out some LSP progress notifications from 'lua_ls'
                return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
              end
              local custom_sort = function(notif_arr) return notify.default_sort(vim.tbl_filter(predicate, notif_arr)) end

              notify.setup({ content = { sort = custom_sort } })
              vim.notify = notify.make_notify()
            end,
          },
          {
            module = 'mini.trailspace',
            config = function()
              M.map('n', '<Leader>ct', require('mini.trailspace').trim, { desc = 'Code Trim trailspace' })
            end,
          },
          {
            module = 'mini.hipatterns',
            config = function()
              -- See :help MiniHipatterns-examples
              local hipatterns = require('mini.hipatterns')
              local hi_words = require('mini.extra').gen_highlighter.words
              hipatterns.setup({
                highlighters = {
                  fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
                  hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
                  todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
                  note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

                  hex_color = hipatterns.gen_highlighter.hex_color(),
                },
              })
              M.map('n', '<Leader>cc', hipatterns.toggle, { desc = 'Code Colorizer' })
            end,
          },
        }, 'config')
      end,
    },

    -- Setup Lsp
    {
      source = 'neovim/nvim-lspconfig',
      config = function()
        -- Lsp
        vim.lsp.enable({
          'lua_ls',
        })

        -- see :help vim.diagnostic.config()
        vim.diagnostic.config({
          jump = {
            float = true,
          },
          signs = {
            text = { '󰅚 ', '󰀪 ', '󰋽 ', '󰌶 ' }, -- Error, Warn, Info, Hint
          },
          virtual_text = {
            spacing = 2,
            severity = {
              min = vim.diagnostic.severity.WARN, -- leave out Info & Hint
            },
            format = function(diag)
              local msg = diag.message:gsub('%.$', '')
              return msg
            end,
            suffix = function(diag)
              if not diag then return '' end
              local content = (tostring(diag.code or diag.source or ''))
              if content == '' then return '' end
              return (' [%s]'):format(content:gsub('%.$', ''))
            end,
          },
          float = {
            max_width = 70,
            header = '',
            prefix = function(_, _, total) return (total > 1 and '• ' or ''), 'Comment' end,
            suffix = function(diag)
              local source = (diag.source or ''):gsub(' ?%.$', '')
              local code = diag.code and ': ' .. diag.code or ''
              return ' ' .. source .. code, 'Comment'
            end,
            format = function(diag)
              local msg = diag.message:gsub('%.$', '')
              return msg
            end,
          },

          update_in_insert = false,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function()
            local ok, fzf = pcall(require, 'fzf-lua')

            if not ok then return end

            --stylua: ignore
            M.keymaps({
              { '<Leader>la', fzf.lsp_code_actions,    { desc = "Code action" } },
              { '<Leader>lr', fzf.lsp_references,      { desc = "References" } },
              { '<Leader>ld', fzf.lsp_definitions,     { desc = "Definition" } },
              { '<Leader>lD', fzf.lsp_declarations,    { desc = "Declarations" } },
              { '<Leader>li', fzf.lsp_implementations, { desc = "Implementation" } },
              { '<Leader>lf', vim.lsp.buf.format,      { desc = "Format" } },
              { '<Leader>lR', vim.lsp.buf.rename,      { desc = "Rename" } },
            })

            -- Copy the current line and all diagnostics on that line to system clipboard
            M.map('n', 'gyd', function()
              local pos = vim.api.nvim_win_get_cursor(0)
              local line_num = pos[1] - 1 -- 0-indexed
              local line_text = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
              local diagnostics = vim.diagnostic.get(0, { lnum = line_num })
              if #diagnostics == 0 then
                vim.notify('No diagnostic found on this line', vim.log.levels.WARN)
                return
              end
              local message_lines = {}
              for _, d in ipairs(diagnostics) do
                for msg_line in d.message:gmatch('[^\n]+') do
                  table.insert(message_lines, msg_line)
                end
              end
              local formatted = {}
              table.insert(formatted, 'Line:\n' .. line_text .. '\n')
              table.insert(formatted, 'Diagnostic on that line:\n' .. table.concat(message_lines, '\n'))
              vim.fn.setreg('+', table.concat(formatted, '\n\n'))
              vim.notify('Line and diagnostic copied to clipboard', vim.log.levels.INFO)
            end, { desc = 'Yank line and diagnostic to system clipboard' })
          end,
        })
      end,
    },

    -- Auto completion
    -- See :help blink-cmp-installation-mini.deps
    {
      source = 'saghen/blink.cmp',
      checkout = 'v1.3.1',
      opts = {
        enabled = function() return not vim.tbl_contains({ 'bigfile' }, vim.bo.filetype) end,
        cmdline = {
          enabled = false,
        },
        keymap = { preset = 'super-tab' },

        completion = { documentation = { auto_show = false } },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            lsp = { fallbacks = {} },
            snippets = {
              -- don't show when triggered manually (= length 0), useful
              -- when manually showing completions to see available fields
              min_keyword_length = 1,
              score_offset = 3,
              opts = { clipboard_register = '+' }, -- register to use for `$CLIPBOARD`
            },
            path = {
              opts = { get_cwd = vim.uv.cwd },
            },
            buffer = {
              max_items = 4,
              min_keyword_length = 3,

              score_offset = -7,

              opts = {
                -- show completions from all buffers used within the last x minutes
                get_bufnrs = function()
                  local mins = 15
                  local allOpenBuffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
                  local recentBufs = vim
                    .iter(allOpenBuffers)
                    :filter(function(buf)
                      local recentlyUsed = os.time() - buf.lastused < (60 * mins)
                      local nonSpecial = vim.bo[buf.bufnr].buftype == ''
                      return recentlyUsed and nonSpecial
                    end)
                    :map(function(buf) return buf.bufnr end)
                    :totable()
                  return recentBufs
                end,
              },
            },
          },
        },
        appearance = {
          nerd_font_variant = 'mono',
          -- make lsp icons different from the corresponding similar blink sources
          kind_icons = {
            Text = '󰉿', -- `buffer`
            Snippet = '󰞘', -- `snippets`
            File = '', -- `path`
            Module = '', -- prettier braces
          },
        },

        fuzzy = { implementation = 'prefer_rust_with_warning' },
      },
    },

    -- Picker
    -- See :help fzf-lua-dependencies
    -- See :help fzf-lua-optional-dependencies
    {
      source = 'ibhagwan/fzf-lua',
      -- See :help fzf-lua-customization
      opts = {
        'max-perf',
        winopts = {
          -- fullscreen = true, -- start fullscreen?
          split = string.format(
            'botright %dnew | setlocal bt=nofile bh=wipe nobl noswf wfh',
            math.floor(vim.o.lines / 3)
          ),
          on_create = function()
            vim.o.cmdheight = 0
            vim.o.laststatus = 0
          end,
          on_close = function()
            vim.o.cmdheight = 1
            vim.o.laststatus = 3
          end,
          preview = {
            hidden = true,
            -- layout = 'vertical',
            -- vertical = 'up:70%',
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
      },
      config = function()
        local fzf = require('fzf-lua')

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

        -- Shorcut cmd Find files
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
          bcword = function() fzf.lgrep_curbuf({ start = 'cursor', query = vim.fn.expand('<cword>') }) end,
          diagnostics = function(opts)
            return fzf.diagnostics_workspace(vim.tbl_extend('force', opts or {}, {
              prompt = 'Workspace Diagnostics> ',
            }))
          end,
          help = function()
            local ok = pcall(vim.cmd.help, vim.fn.expand('<cWORD>'))
            if not ok then fzf.help_tags({ query = vim.fn.expand('<cword>') }) end
          end,
          grep_buffer = function()
            local query = vim.fn.expand('<cword>')
            local path = vim.api.nvim_buf_get_name(0)
            local relpath = vim.fn.fnamemodify(path, ':.')
            local cmd = string.format(
              [[rg --column --line-number --no-heading --color=always --word-regexp --with-filename %q %s]],
              query,
              relpath
            )

            require('fzf-lua').fzf_exec(cmd, {
              prompt = 'Grep buffer> ',
              query = query,
              actions = {
                ['default'] = function(selected, opts)
                  if #selected == 0 then return end
                  if #selected > 1 then
                    fzf.actions.file_sel_to_qf(selected, opts)
                  else
                    local filename, line, col, text = selected[1]:match('([^:]+):(%d+):(%d+):?(.*)$')
                    if tonumber(line) then
                      vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 or 0 })
                    end
                    vim.fn.setreg('/', query)
                  end
                end,
              },
              previewer = false,
            })
          end,
        }

        local Fzf = vim.tbl_deep_extend('force', vim.deepcopy(require('fzf-lua')), custom)

        --stylua: ignore
        M.keymaps({
          { '*',           Fzf.grep_buffer,     { desc = 'Open buffer word picker' } },
          { 'z=',          Fzf.spell_suggest,   { desc = 'Open spell suggest picker' } },
          { '<F1>',        Fzf.help,            { desc = 'Open nvim help picker' } },
          { '<C-f>',       Fzf.builtin,         { desc = 'Open builtin picker',       mode = 'nv' } },
          { '<Leader>f',   Fzf.files,           { desc = 'Open file picker' } },
          { '<Leader>ps',  Fzf.grep_visual,     { desc = 'Open search visual picker', mode = 'v' } },
          { '<Leader>ps',  Fzf.grep_cword,      { desc = 'Open search word picker' } },
          { '<Leader>pi',  Fzf.grep,            { desc = 'Open search input picker' } },
          { '<Leader>pf',  Fzf.git_files,       { desc = 'Open gitfiles picker' } },
          { '<Leader>po',  Fzf.oldfiles,        { desc = 'Open oldfiles picker' } },
          { '<Leader>pb',  Fzf.buffers,         { desc = 'Open buffer picker' } },
          { '<Leader>pd',  Fzf.diagnostics,     { desc = 'Open diagnostics picker' } },
          { '<Leader>pr',  Fzf.resume,          { desc = 'Open last picker' } },
          { '<Leader>phc', Fzf.command_history, { desc = 'Open command history picker' } },
          { '<Leader>phs', Fzf.search_history,  { desc = 'Open search history picker' } },
          { '<Leader>pnk', Fzf.keymaps,         { desc = 'Open nvim keymap picker' } },
          { '<Leader>pnf', Fzf.filetypes,       { desc = 'Open nvim filetype picker' } },
          { '<Leader>pnh', Fzf.highlights,      { desc = 'Open nvim highlights picker' } },
          { '<Leader>pnc', Fzf.config,          { desc = 'Open nvim config picker' } },
          { '<C-x><C-f>',  Fzf.complete_path,   { desc = 'Open complete path picker', mode = 'i' } },
          { '<C-x><C-l>',  Fzf.complete_line,   { desc = 'Open complete line picker', mode = 'i' } },
        })
      end,
    },

    -- Git wrapper
    {
      source = 'tpope/vim-fugitive',
      config = function()
        -- See :help fugitive-commands
        local git = {
          git = 'vert Git',
          write = 'Gwrite',
          read = 'Gread',
          vdiff = 'Gvdiffsplit',
          diff = 'Gdiffsplit',
          blame = 'Git blame',
          push = 'Git push',
          pull = 'Git pull',
          pull_rebase = 'Git pull --rebase',
          log_buffer = 'Git log --stat %',
          log_project = 'Git log --stat -n 100',
        }

        for k, v in pairs(git) do
          git[k] = '<cmd>' .. v .. '<cr>'
        end

        --stylua: ignore
        M.keymaps({
          { '<Leader>gg', git.git,         { desc = 'Git' } },
          { '<Leader>gw', git.write,       { desc = 'Git write (stage)' } },
          { '<Leader>gr', git.read,        { desc = 'Git read (reset)' } },
          { '<Leader>gv', git.vdiff,       { desc = 'Git diff (buffer)' } },
          { '<Leader>gl', git.log_buffer,  { desc = 'Git log (buffer)' } },
          { '<Leader>gL', git.log_project, { desc = 'Git log (project)' } },
        })

        vim.api.nvim_create_autocmd('FileType', {
          pattern = '*',
          desc = 'Ensure that fugitive buffers are not listed and are wiped out after hidden.',
          callback = function(info)
            if vim.bo.ft ~= 'fugitive' then return end
            vim.bo[info.buf].buflisted = false
            local opts = { buffer = true }

            vim.b.miniclue_disable = true

            M.keymaps({
              { 'q', vim.cmd.bd },

              { '<Leader>p', git.push, { desc = 'Git push' } },
              { '<Leader>f', git.pull, { desc = 'Git pull' } },
              { '<Leader>r', git.pull_rebase, { desc = 'Git rebase' } }, -- rebase always

              -- NOTE: It allows me to easily set the branch i am pushing and any tracking
              -- needed if i did not set the branch up correctly
              { '<Leader>P', ':Git push -u origin ', { silent = false, desc = 'Git push -u origin' } },
            }, opts)
          end,
        })
      end,
    },

    -- Formatter
    {
      source = 'stevearc/conform.nvim',
      name = 'conform',
      opts = {
        formatters_by_ft = {
          lua = { 'stylua' }, -- https://github.com/JohnnyMorganz/StyLua?tab=readme-ov-file#installation
          ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
      },
      config = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        local format_buf = function() require('conform').format({ async = true, lsp_format = 'fallback' }) end
        M.map('n', 'gq', format_buf, { desc = 'format with conform' })
      end,
    },

    -- Colorscheme
    {
      source = 'rose-pine/neovim',
      name = 'rose-pine',
      lazy = false,
      opts = {
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
          transparency = false, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },

        palette = {
          -- Override the builtin palette per variant
          moon = {
            pine = '#5db5da',
          },
        },

        -- NOTE: Highlight groups are extended (merged) by default. Disable this
        -- per group via `inherit = false`
        highlight_groups = {
          Cursor = { bg = 'text' },
          Normal = { bg = 'none' },
          NormalNC = { bg = 'none' },
          NormalFloat = { bg = 'none' },
          FloatBorder = { bg = 'none' },
          MiniClueTitle = { bg = 'none' },
          Pmenu = { bg = 'none' },
          FzfLuaBorder = { bg = 'none' },
          BlinkCmpLabel = { fg = 'subtle' },
          -- StatusLine = { fg = "love", bg = "love", blend = 15 },
          -- VertSplit = { fg = "muted", bg = "muted" },
          -- Visual = { fg = "base", bg = "text", inherit = false },
        },
      },
      config = function() vim.cmd('colo rose-pine-moon') end,
    },

    -- Tree-sitter (advanced syntax parsing, highlighting, textobjects)
    {
      source = 'nvim-treesitter/nvim-treesitter',
      checkout = 'master',
      hooks = {
        post_checkout = function() vim.cmd('TSUpdate') end,
      },
      name = 'nvim-treesitter.configs',
      opts = {
        disable = { 'bigfile' },
        auto_install = true,
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
        },
        highlight = { enable = true },
        incremental_selection = { enable = false },
        textobjects = { enable = false },
        indent = { enable = false },
      },
      config = function()
        -- Disable injections in 'lua' language
        local ts_query = require('vim.treesitter.query')
        local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
        ts_query_set('lua', 'injections', '')
      end,
    },
    { source = 'nvim-treesitter/nvim-treesitter-textobjects' },
  }
end
--------------------------------------------------------------------------------
--- UTILS
--------------------------------------------------------------------------------
local valid_modes = { n = true, i = true, v = true, x = true, s = true, o = true, c = true, t = true }

-- Parse a mode string into an array of mode characters
local function parse_modes(mode_str)
  if mode_str == nil then return { 'n' } end
  local modes = {}
  for i = 1, #mode_str do
    local char = mode_str:sub(i, i)
    if valid_modes[char] then table.insert(modes, char) end
  end
  return modes
end

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.remap == nil and true or not opts.remap
  opts.silent = opts.silent ~= false
  vim.keymap.set(type(modes) == 'string' and parse_modes(modes) or modes, lhs, rhs, opts)
end

function M.keymaps(keymaps, global_opts)
  for _, mapping in ipairs(keymaps) do
    local lhs, rhs, raw_opts = mapping[1], mapping[2], vim.tbl_deep_extend('force', global_opts or {}, mapping[3] or {})
    local modes = parse_modes(raw_opts.mode)
    local opts = vim.deepcopy(raw_opts)
    opts.mode = nil
    M.map(modes, lhs, rhs, opts)
  end
end

function M.toggle_qf(type)
  local wininfo = vim.fn.getwininfo()
  local windows = {}
  -- collect matching windows
  for _, win in ipairs(wininfo) do
    if type == 'l' and win.loclist == 1 then
      table.insert(windows, win.winid)
    elseif type == 'q' and win.quickfix == 1 and win.loclist == 0 then
      table.insert(windows, win.winid)
    end
  end

  if #windows > 0 then
    -- if any qf/loclist windows are open, close them
    for _, winid in ipairs(windows) do
      vim.api.nvim_win_hide(winid)
    end
  else
    if type == 'l' then
      -- open all non-empty loclists
      for _, win in ipairs(wininfo) do
        if win.quickfix == 0 then
          if not vim.tbl_isempty(vim.fn.getloclist(win.winnr)) then
            vim.api.nvim_set_current_win(win.winid)
            vim.cmd('lopen')
            vim.cmd('wincmd J')
          else
            print('loclist is empty.')
          end
          return
        end
      end
    else
      -- open quickfix if not empty
      if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd('copen')
        vim.cmd('wincmd J')
      else
        print('quickfix is empty.')
      end
    end
  end
end


-- Minimal multi-instance floating terminal in Neovim
-- Toggle terminal with <count><C-t>, e.g.:
--    <C-t>    → toggle terminal #1
--    2<C-t>   → toggle terminal #2
local terms = {}

local function float_cfg()
  return {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
  }
end

function M.toggle_floating_term()
  local count = vim.v.count
  if count == 0 then count = 1 end

  -- create state if not exists
  terms[count] = terms[count] or { buf = nil, win = nil, was_insert = true }

  local state = terms[count]
  local buf, win = state.buf, state.win

  -- validate
  buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
  win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
  state.buf, state.win = buf, win

  if not buf and not win then
    -- new terminal
    vim.cmd('split | terminal')
    buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
    win = vim.api.nvim_open_win(buf, true, float_cfg())
    state.buf = buf
    state.win = win
  elseif not win and buf then
    -- reopen
    win = vim.api.nvim_open_win(buf, true, float_cfg())
    state.win = win
  elseif win then
    -- close
    state.was_insert = vim.api.nvim_get_mode().mode == 't'
    vim.api.nvim_win_close(win, true)
    state.win = nil
    return
  end

  if state.was_insert then vim.cmd('startinsert') end
end

-- taken from: https://github.com/rebelot/dotfiles/blob/0b7e3b4f5063173f38d69a757ab03a8d9323af2e/nvim/lua/utilities.lua#L3
function M.visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local escape_characters = '"\\/.*$^~[]'

function _G.get_visual_selection(escape)
  local sr, sc, er, ec = M.visual_selection_range()
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
  if #text == 1 then return escape ~= false and vim.fn.escape(text[1], escape_characters) or text[1] end
end

--- Register plugins or configs.
--- @param plugins table[] List of plugin spec or config tables
--- @param opt 'plugin'|'config' Determines the mode: 'plugin' = deps.add, 'config' = direct require+setup
function M.register_plugins(plugins, opt)
  local ok, MiniDeps = pcall(require, 'mini.deps')
  if not ok then return end

  local now_setups, later_setups = {}, {}

  -- Helper: setup plugin
  --- @param module string
  --- @param opts? table
  local function setup_plugin(module, opts)
    local ok, plugin = pcall(require, module)
    if ok and plugin and type(plugin.setup) == 'function' then
      plugin.setup(opts or {})
    else
      vim.notify('Failed to load or setup module: ' .. module, vim.log.levels.WARN)
    end
  end

  --- @param entry table
  local function run_config(entry)
    if type(entry.config) == 'function' then entry.config() end
  end

  for _, entry in ipairs(plugins) do
    local lazy = entry.lazy ~= false -- default true

    local runner = (opt == 'config')
        and function()
          if entry.setup ~= false then setup_plugin(entry.module, entry.opts) end
          run_config(entry)
        end
      or function()
        local _, plugin_name
        if type(entry.source) == 'string' then
          _, plugin_name = entry.source:match('([^/]+)/([^/]+)')
        end
        local module = entry.name or plugin_name
        local spec = vim.deepcopy(entry)
        spec.lazy = nil

        -- See :help MiniDeps.add()
        MiniDeps.add(spec)
        if entry.setup ~= false and type(entry.opts) == 'table' then setup_plugin(module, entry.opts) end
        run_config(entry)
      end

    table.insert(lazy and later_setups or now_setups, runner)
  end

  for _, fn in ipairs(now_setups) do
    -- See :help MiniDeps.now()
    MiniDeps.now(fn)
  end
  for _, fn in ipairs(later_setups) do
    -- See :help MiniDeps.later()
    MiniDeps.later(fn)
  end
end

--------------------------------------------------------------------------------
--- Bootstrap mini.nvim and set up mini.deps
--------------------------------------------------------------------------------
-- taken from: https://github.com/echasnovski/mini.nvim?tab=readme-ov-file#installation
function M.bootstrap()
  local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/echasnovski/mini.nvim',
      mini_path,
    })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end

  local ok, deps = pcall(require, 'mini.deps')
  if ok then deps.setup() end
end

-- Pretty print
function _G.P(...)
  local p = { ... }
  for i = 1, select('#', ...) do
    p[i] = vim.inspect(p[i])
  end
  print(table.concat(p, ', '))
  return ...
end

-- Run setup in sequence
local function setup()
  coroutine.wrap(function()
    if M.load_options then load_options() end
    if M.load_autocmds then load_autocmds() end
    if M.load_keymaps then load_keymaps() end
    if M.load_plugins then
      M.bootstrap()
      M.register_plugins(M.plugins(), 'plugin')
    end
  end)()
end

setup()

--------------------------------------------------------------------------------
