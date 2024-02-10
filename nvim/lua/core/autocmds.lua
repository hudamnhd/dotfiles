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

augroup('BigFileSettings', {
  'BufReadPre',
  {
    desc = 'Set settings for large files.',
    callback = function(info)
      vim.b.midfile = false
      vim.b.bigfile = false
      local stat = vim.uv.fs_stat(info.match)
      if not stat then
        return
      end
      if stat.size > 48000 then
        vim.b.midfile = true
        autocmd('BufReadPost', {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.schedule(function()
              pcall(vim.treesitter.stop, info.buf)
            end)
            return true
          end,
        })
      end
      if stat.size > 1024000 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''
        autocmd('BufReadPost', {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.opt_local.syntax = ''
            return true
          end,
        })
      end
    end,
  },
})

augroup('YankHighlight', {
  'TextYankPost',
  {
    desc = 'Highlight the selection on yank.',
    callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
    end,
  },
})

augroup('Autosave', {
  { 'BufLeave', 'WinLeave', 'FocusLost' },
  {
    nested = true,
    desc = 'Autosave on focus change.',
    callback = function(info)
      if vim.bo[info.buf].bt == '' then
        vim.cmd.update({
          mods = { emsg_silent = true },
        })
      end
    end,
  },
})

augroup('WinCloseJmp', {
  'WinClosed',
  {
    nested = true,
    desc = 'Jump to last accessed window on closing the current one.',
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

augroup('LastPosJmp', {
  'BufReadPost',
  {
    desc = 'Last position jump.',
    callback = function(info)
      local ft = vim.bo[info.buf].ft
      -- don't apply to git messages
      if ft ~= 'gitcommit' and ft ~= 'gitrebase' then
        vim.cmd.normal({
          'g`"zvzz',
          bang = true,
          mods = { emsg_silent = true },
        })
      end
    end,
  },
})

augroup('AutoCwd', {
  { 'BufWinEnter', 'FileChangedShellPost' },
  {
    pattern = '*',
    desc = 'Automatically change local current directory.',
    callback = function(info)
      if info.file == '' or vim.bo[info.buf].bt ~= '' then
        return
      end

      local current_dir = vim.fn.getcwd(0)
      local target_dir = require('utils').fs.proj_dir(info.file)
        or vim.fs.dirname(info.file)
      local stat = target_dir and vim.uv.fs_stat(target_dir)
      -- Prevent unnecessary directory change, which triggers
      -- DirChanged autocmds that may update winbar unexpectedly
      if current_dir ~= target_dir and stat and stat.type == 'directory' then
        vim.cmd.lcd(target_dir)
      end
    end,
  },
})

augroup('GQFormatter', {
  { 'FileType', 'LspAttach' },
  {
    pattern = '*',
    desc = 'Automatically change local current directory.',
    callback = function(e)
      -- priortize LSP formatting as `gq`
      if e.file:match('^fugitive:') then
        return
      end
      local lsp_has_formatting = false
      local lsp_clients = vim.lsp.get_active_clients()
      local lsp_keymap_set = function(m, c)
        vim.keymap.set(m, 'gq', function()
          vim.lsp.buf.format({ async = true, bufnr = e.buf })
        end, {
          silent = true,
          buffer = e.buf,
          desc = string.format('format document [LSP:%s]', c.name),
        })
      end
      vim.tbl_map(function(c)
        if
          c.supports_method('textDocument/rangeFormatting', { bufnr = e.buf })
        then
          lsp_keymap_set('x', c)
          lsp_has_formatting = true
        end
        if c.supports_method('textDocument/formatting', { bufnr = e.buf }) then
          lsp_keymap_set('n', c)
          lsp_has_formatting = true
        end
      end, lsp_clients)
      -- check conform.nvim for formatters:
      --   (1) if we have no LSP formatter map as `gq`
      --   (2) if LSP formatter exists, map as `gQ`
      local ok, conform = pcall(require, 'conform')
      local formatters = ok and conform.list_formatters(e.buf) or {}
      if #formatters > 0 then
        vim.keymap.set('n', lsp_has_formatting and 'gQ' or 'gq', function()
          require('conform').format({
            async = true,
            buffer = e.buf,
            lsp_fallback = false,
          })
        end, {
          silent = true,
          buffer = e.buf,
          desc = string.format('format document [%s]', formatters[1].name),
        })
      end
    end,
  },
})

augroup('PromptBufKeymaps', {
  'BufEnter',
  {
    desc = 'Undo automatic <C-w> remap in prompt buffers.',
    callback = function(info)
      if vim.bo[info.buf].buftype == 'prompt' then
        vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
      end
    end,
  },
})

augroup('QuickFixAutoOpen', {
  'QuickFixCmdPost',
  {
    desc = 'Open quickfix window if there are results.',
    callback = function(info)
      if #vim.fn.getqflist() > 1 then
        vim.schedule(vim.cmd[info.match:find('^l') and 'lwindow' or 'cwindow'])
      end
    end,
  },
})

augroup('KeepWinRatio', {
  { 'VimResized', 'TabEnter' },
  {
    desc = 'Keep window ratio after resizing nvim.',
    callback = function()
      vim.cmd.wincmd('=')
      require('utils.win').restratio(vim.api.nvim_tabpage_list_wins(0))
    end,
  },
}, {
  { 'TermOpen', 'WinResized' },
  {
    desc = 'Record window ratio.',
    callback = function()
      -- Don't record ratio if window resizing is caused by vim resizing
      -- (changes in &lines or &columns)
      local lines, columns = vim.go.lines, vim.go.columns
      local _lines, _columns = vim.g._lines, vim.g._columns
      if _lines and lines ~= _lines or _columns and columns ~= _columns then
        vim.g._lines = lines
        vim.g._columns = columns
        return
      end

      local now = vim.uv.now()
      vim.g._wr_winresized = now
      if vim.v.event.windows then
        _G._wr_windows = _G._wr_windows or {}
        for _, win in ipairs(vim.v.event.windows) do
          _G._wr_windows[win] = true
        end
      end
      vim.defer_fn(function()
        if vim.g._wr_winresized == now then
          local wins = _G._wr_windows
              and not vim.tbl_isempty(_G._wr_windows)
              and vim.tbl_keys(_G._wr_windows)
            or vim.api.nvim_list_wins()
          require('utils.win').saveratio(wins)
          _G._wr_windows = nil
        end
      end, 200)
    end,
  },
})

-- Show cursor line and cursor column only in current window
augroup('AutoHlCursorLine', {
  { 'BufWinEnter', 'WinEnter' },
  {
    desc = 'Show cursorline and cursorcolumn in current window.',
    callback = function()
      if vim.w._cul and not vim.wo.cul then
        vim.wo.cul = true
        vim.w._cul = nil
      end
      if vim.w._cuc and not vim.wo.cuc then
        vim.wo.cuc = true
        vim.w._cuc = nil
      end
    end,
  },
}, {
  'WinLeave',
  {
    desc = 'Hide cursorline and cursorcolumn in other windows.',
    callback = function()
      if vim.wo.cul then
        vim.w._cul = true
        vim.wo.cul = false
      end
      if vim.wo.cuc then
        vim.w._cuc = true
        vim.wo.cuc = false
      end
    end,
  },
})

augroup('FixCmdLineIskeyword', {
  'CmdLineEnter',
  {
    desc = 'Have consistent &iskeyword and &lisp in Ex command-line mode.',
    pattern = '[^/?]',
    callback = function(info)
      -- Don't set &iskeyword and &lisp settings in search command-line
      -- ('/' and '?'), if we are searching in a lisp file, we want to
      -- have the same behavior as in insert mode
      vim.g._isk_lisp_buf = info.buf
      vim.g._isk_save = vim.bo[info.buf].isk
      vim.g._lisp_save = vim.bo[info.buf].lisp
      vim.cmd.setlocal('isk&')
      vim.cmd.setlocal('lisp&')
    end,
  },
}, {
  'CmdLineLeave',
  {
    desc = 'Restore &iskeyword after leaving command-line mode.',
    pattern = '[^/?]',
    callback = function()
      if
        vim.g._isk_lisp_buf
        and vim.api.nvim_buf_is_valid(vim.g._isk_lisp_buf)
        and vim.g._isk_save ~= vim.b[vim.g._isk_lisp_buf].isk
      then
        vim.bo[vim.g._isk_lisp_buf].isk = vim.g._isk_save
        vim.bo[vim.g._isk_lisp_buf].lisp = vim.g._lisp_save
        vim.g._isk_save = nil
        vim.g._lisp_save = nil
        vim.g._isk_lisp_buf = nil
      end
    end,
  },
})

augroup('SpecialBufHl', {
  { 'BufWinEnter', 'BufNew', 'FileType', 'TermOpen' },
  {
    desc = 'Set background color for special buffers.',
    callback = function(info)
      -- Current window isn't necessarily the window of the buffer that
      -- triggered the event, use `bufwinid()` to get the first window of
      -- the triggering buffer. We can also use `win_findbuf()` to get all
      -- windows that display the triggering buffer, but it is slower and using
      -- `bufwinid()` is enough for our purpose.
      local winid = vim.fn.bufwinid(info.buf)
      if winid == -1 then
        return
      end
      vim.api.nvim_win_call(winid, function()
        local wintype = vim.fn.win_gettype()
        if wintype == 'popup' or wintype == 'autocmd' then
          return
        end
        if vim.bo[info.buf].bt ~= '' then
          vim.opt_local.winhl:append({
            Normal = 'NormalSpecial',
            EndOfBuffer = 'NormalSpecial',
          })
        end
      end)
    end,
  },
}, {
  { 'UIEnter', 'ColorScheme' },
  {
    desc = 'Set special buffer normal hl.',
    callback = function()
      local hl = require('utils.hl')
      local blended = hl.blend('Normal', 'Normal')
      hl.set_default(0, 'NormalSpecial', blended)
    end,
  },
})

augroup('SpecialBufHeight', {
  'WinNew',
  {
    desc = 'Record time when a new window is created',
    callback = function()
      if not vim.w._created then
        vim.w._created = vim.uv.now()
      end
    end,
  },
}, {
  { 'BufWinEnter', 'TermOpen' },
  {
    desc = 'Set a smaller window height for some special buffers.',
    callback = function(info)
      local bo = vim.bo[info.buf]
      local bt = bo.bt
      local ft = bo.ft
      if
        ft == 'netrw'
        or ft == 'oil'
        or bt == ''
        or bt == 'quickfix'
        or bt == 'prompt'
        or vim.wo.wfh
        or vim.fn.win_gettype() ~= ''
      then
        return
      end

      -- Don't resize when the window is created manually
      if vim.w._created and vim.uv.now() - vim.w._created > 100 then
        return
      end

      -- Don't resize if the window will be larger after resizing
      local height = math.ceil((vim.go.lines - vim.go.ch) * 0.36)
      if height < vim.go.hh or height >= vim.api.nvim_win_get_height(0) then
        return
      end

      -- Don't resize if it will affect other windows in an undesirable way

      -- If the window has no other windows above or below it,
      -- resizing it will cause cmdheight to change
      local win = vim.fn.winnr()
      local win_bel = vim.fn.winnr('j')
      local win_abv = vim.fn.winnr('k')
      if win_bel == win and win_abv == win then
        return
      end

      -- If the window has other windows above or below and has no
      -- window on the left or right, resizing it will be safe
      local win_left = vim.fn.winnr('h')
      local win_right = vim.fn.winnr('l')
      if win_left == win and win_right == win then
        goto resize
        return
      end

      -- If the window has left/right windows that has the same above/below
      -- window with it, they are sharing the same 'grid', so resizing the
      -- window will also resize its left/right windows in the same direction,
      -- which is undesirable:
      --
      --  +-----------------+
      --  |  win A          |
      --  |                 |
      --  +--------+--------+  ==> resizing C will also resize B in the same
      --  | win B  | win C  |      direction, don't resize
      --  |        | (new)  |
      --  +--------+--------+
      --
      --  +--------+--------+
      --  |  win A | win B  |
      --  |        |        |
      --  |        +--------+  ==> resizing C will not affect other windows
      --  |        | win C  |      in an undesirable way, can resize
      --  |        | (new)  |
      --  +--------+--------+
      do
        if win_left ~= win then
          -- stylua: ignore start
          local winid_left = vim.fn.win_getid(win_left)
          local win_lbel = vim.api.nvim_win_call(winid_left, function() return vim.fn.winnr('j') end)
          local win_labv = vim.api.nvim_win_call(winid_left, function() return vim.fn.winnr('k') end)
          -- stylua: ignore end
          if win_lbel == win_bel or win_labv == win_abv then
            return
          end
        end
        if win_right ~= win then
          -- stylua: ignore start
          local winid_right = vim.fn.win_getid(win_right)
          local win_rbel = vim.api.nvim_win_call(winid_right, function() return vim.fn.winnr('j') end)
          local win_rabv = vim.api.nvim_win_call(winid_right, function() return vim.fn.winnr('k') end)
          -- stylua: ignore end
          if win_rbel == win_bel or win_rabv == win_abv then
            return
          end
        end
      end

      ::resize::
      vim.api.nvim_win_set_height(0, height)
    end,
  },
})

local function open_vert()
  -- do nothing for floating windows or if this is
  -- the fzf-lua minimized help window (height=1)
  local cfg = vim.api.nvim_win_get_config(0)
  if
    cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
    or vim.api.nvim_win_get_height(0) == 1
  then
    return
  end
  -- do not run if Diffview is open
  if
    vim.g.diffview_nvim_loaded and require('diffview.lib').get_current_view()
  then
    return
  end
  local width = math.floor(vim.o.columns * 0.75)
  vim.cmd('wincmd L')
  vim.cmd('vertical resize ' .. width)
  vim.keymap.set('n', 'q', '<CMD>q<CR>', { buffer = true })
end

augroup('Help', {
  { 'FileType' },
  {
    pattern = 'help,man',
    callback = open_vert,
  },
})

augroup('Help', {
  { 'BufEnter' },
  {
    pattern = '*.txt',
    callback = function()
      if vim.bo.buftype == 'help' then
        open_vert()
      end
    end,
  },
})

augroup('Help', {
  { 'BufEnter' },
  {
    pattern = '*.txt',
    callback = function()
      if vim.bo.buftype == 'help' then
        open_vert()
      end
    end,
  },
})

augroup('ChangeFileType', {
  { 'BufRead', 'BufWritePre' },
  {
    pattern = '*.blade.php',
    desc = 'Set balde to php syntax',
    command = 'setlocal ft=php',
  },
})
