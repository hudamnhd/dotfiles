-------------------------------------------------------------------------------
-- Main Config ================================================================
-------------------------------------------------------------------------------
local H = {
  Config = {
    leader_key = '\\',

    -- Feature
    features = {
      options        = true,
      grep           = true,
      toggle_options = true,
      zenmode        = true,
      quickfix       = true,
      netrw          = false,

      autocommands   = {
        basic    = true,
        bigfile  = true,
        autosave = true,
        terminal = true,
      },

      keymaps        = {
        basic         = true,
        multi_cursors = true,
        autoclose     = false,
        substitute    = true,
        window        = true,
        readline      = true,
      },
    },

    -- Non-feature config
    keymaps = {
      disabled  = { 'q', 's', '<c-z>', '<space>' },        -- disable these entirely
      blackhole = { 'c', 'x', '<s-s>', '<s-d>', '<s-c>' }, -- map to '_ delete
      delimiter = { prefix = 'd', keys = { ',', ';', '.' },
      },
    },
  },
}

local C = H.Config
-------------------------------------------------------------------------------
-- Options ====================================================================
-------------------------------------------------------------------------------

local options = function()
  local o, opt    = vim.o, vim.opt

  -- Leader key
  vim.g.mapleader = C.keymaps.leader_key

  -- General
  o.undofile      = true -- Enable persistent undo (see also `:h undodir`)
  o.undodir       = os.getenv('HOME') .. '/.vim/undodir'

  o.swapfile      = false
  o.backup        = false
  o.writebackup   = false

  o.mouse         = 'a' -- Enable mouse for all available modes

  -- Enable all filetype plugins
  vim.cmd('filetype plugin indent on')

  -- Appearance
  o.hlsearch       = false   -- disable highlight match search
  o.breakindent    = true    -- Indent wrapped lines to match line start
  o.cursorline     = true    -- Highlight current line
  o.linebreak      = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
  o.number         = true    -- Show line numbers
  o.relativenumber = true    -- Relativenumber numbers
  o.splitbelow     = true    -- Horizontal splits will be below
  o.splitright     = true    -- Vertical splits will be to the right

  o.ruler          = false   -- Don't show cursor position in command line
  o.showmode       = false   -- Don't show mode in command line
  o.wrap           = false   -- Display long lines as just one line

  o.signcolumn     = 'yes'   -- Always show sign column (otherwise it will shift text)
  o.fillchars      = 'eob: ' -- Don't show `~` outside of buffer

  -- Editing
  o.ignorecase     = true -- Ignore case when searching (use `\C` to force not doing that)
  o.incsearch      = true -- Show search results while typing
  o.infercase      = true -- Infer letter cases for a richer built-in keyword completion
  o.smartcase      = true -- Don't ignore case when searching if pattern has upper case
  o.smartindent    = true -- Make indenting smart


  o.tabstop       = 2 -- Tab indentation levels every two columns
  o.softtabstop   = 2 -- Tab indentation when mixing tabs & spaces
  o.shiftwidth    = 2 -- Indent/outdent by two columns
  o.shiftround    = true -- Always indent/outdent to nearest tabstop
  o.expandtab     = true -- Convert all tabs that are typed into spaces

  o.completeopt   = 'menuone,noinsert,noselect' -- Customize completions
  o.virtualedit   = 'block' -- Allow going past the end of line in visual block mode
  o.formatoptions = 'qjl1' -- Don't autoformat comments
  o.inccommand    = 'split' -- Shows the effects of |:substitute|

  opt.shortmess:append('Wc') -- Reduce command line messages

  o.termguicolors = true -- Enable gui colors
  o.confirm       = true
  o.pumblend      = 10 -- Make builtin completion menus slightly transparent
  o.pumheight     = 10 -- Make popup menu smaller
  o.winblend      = 10 -- Make floating windows slightly transparent

  o.listchars     = 'tab:> ,extends:…,precedes:…,nbsp:␣' -- Define which helper symbols to show
  o.list          = true -- Show some helper symbols

  -- Enable syntax highlighting if it wasn't already (as it is time consuming)
  if vim.fn.exists('syntax_on') ~= 1 then vim.cmd([[syntax enable]]) end

  local border_chars = 'vert:│,horiz:─,horizdown:┬,horizup:┴,verthoriz:┼,vertleft:┤,vertright:├'
  vim.opt.fillchars:append(border_chars)
end

-------------------------------------------------------------------------------
-- Keymaps ====================================================================
-------------------------------------------------------------------------------

-- ( Keymaps: Multiple Cursors )
-------------------------------------------------------------------------------
local multi_cursors = function()
  -- see: http://www.kevinli.co/p<space>pnosts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript
  local mc_select = [[y/\V\C<C-r>=escape(@", '/')<CR><CR>]]
  local function mc_macro(selection)
    selection = selection or ""

    return function()
      if vim.fn.reg_recording() == "z" then
        return "q"
      end

      if vim.fn.getreg("z") ~= "" then
        return "n@z"
      end

      return selection .. "*Nqz"
    end
  end

  H.map.n("<F7>", [[*Nqz]], { desc = "mc start macro (foward)" })
  H.map.n("<F8>", mc_macro(), { desc = "mc end or replay macro", expr = true })
  H.map.x("<F7>", mc_select .. "``qz", { desc = "mc start macro (foward)" })
  H.map.x("<F8>", mc_macro(mc_select), { desc = "mc end or replay macro", expr = true })
end

-- ( Keymaps: Subtitute )
-------------------------------------------------------------------------------
local substitute = function()
  local function left(count)
    return string.rep("<left>", count)
  end

  local pattern = {
    selection = H.visual_charwise_selection,
    cword = ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI' .. left(3),
    cWord = ':%s/\\V<C-r><C-a>/<C-r><C-a>/gI' .. left(3),
    buffer = ':%s///gI' .. left(4),
    visual = ':s///gI' .. left(4),
  }
  -- Search replace
  H.map.x('<C-G><C-F>', pattern.selection, { desc = 'search and replace selection' })

  H.map.n('<C-G><C-F>', pattern.cword, { silent = false, desc = 'search and replace word' })
  H.map.n('<C-G><C-A>', pattern.cWord, { silent = false, desc = 'search and replace Word' })

  H.map.n('<C-G><C-S>', pattern.buffer, { silent = false, desc = 'search and replace buffer' })
  H.map.x('<C-G><C-S>', pattern.visual, { silent = false, desc = 'search and replace visual' })

  -- Global Search Replace Quickfix
  -- * `:cdo` = "run every line in Quickfix"  | :cdo %s/foo/bar/g  | update
  -- * `:cfdo` = "run every file in Quickfix" | :cfdo %s/foo/bar/g | update

  -- Alternate cgn for easy press
  H.map.n('<bs>', '*N"_cgn', { desc = 'cgn' })
end

-- ( Keymaps: Basic )
-------------------------------------------------------------------------------
local basic_keymaps = function()
  -- Disable key
  H.safe_for_each(C.keymaps.disabled, function(key)
    H.map.nvo(key, '<Nop>')
  end)

  -- Blackhole key (delete without save to register)
  H.safe_for_each(C.keymaps.blackhole, function(key)
    H.map.nvo(key, '"_' .. key)
  end)

  -- delimiters
  H.safe_for_each(C.keymaps.delimiter.keys, function(key)
    H.map.n(C.keymaps.delimiter.prefix .. key, H.modify_line_end_delimiter(key))
  end)

  local smart_dd = function()
    return (vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd")
  end

  -- Very helpful
  H.map.n({
    ["dd"] = smart_dd,
    ["J"]  = [['mz' . v:count1 . 'J`z']],
  }, { expr = true })
  H.map.nvo({
    ['0'] = [[~:]],
    ['<C-H>'] = [[^]],
    ['<C-L>'] = [[g_]],
    ['<C-Z>'] = [[%]],
  }, { remap = true })
  H.map.x({
    ['>'] = [[>gv]],
    ['<'] = [[<gv]],
    -- Move selected lines up/down in visual mode
    ['K'] = [[:move '<-2<CR>gv=gv]],
    ['J'] = [[:move '>+1<CR>gv=gv]],
  })
  H.map.x({
    ['I'] = function() return vim.fn.mode():match('[vV]') and '<C-v>^o^I' or 'I' end,
    ['A'] = function() return vim.fn.mode():match('[vV]') and '<C-v>1o$A' or 'A' end,
  }, { expr = true })

  -- Buffer
  H.map.n({
    ['<a-x>'] = [[!bd]],
    ['<a-X>'] = [[!bw]],
  })
  H.map.t({
    ['<a-x>'] = [[!bw]],
  })

  -- Transform case
  H.map.n({
    ['cl'] = [[mzguiw`z]],
    ['ct'] = [[mzguiwgUl`z]],
    ['cu'] = [[mzgUiw`z]],
  })

  -- Keep matches center screen when cycling with n|N
  H.map.n({
    ['n'] = [[nzzzv]],
    ['N'] = [[nzzzv]],
    ['<C-d>'] = [[<C-d>zz]],
    ['<C-u>'] = [[<C-u>zz]],
  })

  -- Move by visible lines
  H.map.nvo({
    ['j'] = [[v:count == 0 ? 'gj' : 'j']],
    ['k'] = [[v:count == 0 ? 'gk' : 'k']],
  }, { expr = true })

  -- Newline without insert mode
  H.map.n({
    ['<space>o'] = [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
    ['<space>O'] = [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
  }, { desc = 'Newline without insert mode' })

  -- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
  H.map.n('<space>w', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })

  -- Copy/paste with system clipboard
  H.map.n({
    ['<space>y'] = [["+y]],
    ['<space>p'] = [["+p]],
  })
  H.map.x({
    ['<space>y'] = [["+y]],
    ['<space>p'] = [["+P]], -- Paste in Visual with `P` to not copy selected text (`:h v_P`)
  })

  H.map.x('p', 'P', { desc = 'Paste in Visual with `P` to not copy selected text' })

  -- Reselect latest changed, put, or yanked text
  H.map.n('gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"',
    { expr = true, replace_keycodes = false, desc = 'Visually select changed text' })

  -- Search inside visual selection
  H.map.x('g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
end

-- ( Keymaps Autoclose )
-------------------------------------------------------------------------------
local autoclose = function()
  H.map.i({
    ['('] = '()',
    ['"'] = '""',
    ["'"] = "''",
    ['{'] = '{}',
    ['['] = '[]',
    ['/*'] = '/**/'
  })
end

-- ( Keymaps Window )
-------------------------------------------------------------------------------
local window = function()
  -- Window navigation
  H.map.n({
    ['<a-w>'] = [[<C-w>w]],
  })

  H.map.t({
    ['<a-w>'] = [[<C-\><C-n><C-w>w]],
  })

  -- Window resize
  H.map.n({
    ['<C-Up>'] = '<C-w>+',
    ['<C-Down>'] = '<C-w>-',
    ['<C-Left>'] = '<C-w><',
    ['<C-Right>'] = '<C-w>>'
  })
end

-- ( Keymaps Readline )
-------------------------------------------------------------------------------
local readline = function()
  H.map.i('<C-A>', '<C-O>^')
  H.map.c('<C-A>', '<Home>', { silent = false })

  H.map.i('<C-B>', function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    if line:match('^%s*$') and col > #line then
      return '0<C-D><Esc>kJs'
    else
      return '<Left>'
    end
  end, { expr = true })

  H.map.c('<C-B>', '<Left>', { silent = false })

  H.map.i('<C-D>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-D>'
    else
      return '<Del>'
    end
  end, { expr = true })

  H.map.c('<C-D>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return '<C-D>'
    else
      return '<Del>'
    end
  end, { expr = true, silent = false })

  H.map.i('<C-E>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len or vim.fn.pumvisible() == 1 then
      return '<C-E>'
    else
      return '<End>'
    end
  end, { expr = true })

  H.map.i('<C-F>', function()
    local col = vim.fn.col('.')
    local len = #vim.fn.getline('.')
    if col > len then
      return '<C-F>'
    else
      return '<Right>'
    end
  end, { expr = true })

  H.map.c('<C-F>', function()
    local pos = vim.fn.getcmdpos()
    local len = #vim.fn.getcmdline()
    if pos > len then
      return vim.o.cedit
    else
      return '<Right>'
    end
  end, { expr = true, silent = false })
end

-------------------------------------------------------------------------------
-- Quickfix ===================================================================
-------------------------------------------------------------------------------
local quickfix = function()
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

  H.map.n('<space>q', function() H.toggle_qf('q') end, { desc = 'Toggle QF' })
  H.map.n('<space>Q', function() H.toggle_qf('l') end, { desc = 'Toggle LL' })
end
-------------------------------------------------------------------------------
-- Toggle Options =============================================================
-------------------------------------------------------------------------------
local toggle_options = function()
  local toggle_options = {
    "cursorline",
    "cursorcolumn",
    "hlsearch",
    "ignorecase",
    "list",
    "number",
    "relativenumber",
    "spell",
    "wrap",
  }

  local function toggle_option(option)
    vim.cmd(string.format("setlocal %s! %s?", option, option))
  end

  local function show_toggle_menu()
    vim.ui.select(toggle_options, {
      prompt = "Toggle option:",
      format_item = function(item) return "Toggle '" .. item .. "'" end,
    }, function(choice)
      if choice then toggle_option(choice) end
    end)
  end

  H.map.n('<space>ut', show_toggle_menu, { desc = "Toggle UI option" })
end

-------------------------------------------------------------------------------
-- Autocommands ================================================================
-------------------------------------------------------------------------------
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

-- ( Autocommands Basic )
-------------------------------------------------------------------------------
local autocommands = function()
  augroup('HelpOpenVert', {
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
  })

  augroup('YankHighlight', {
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
  })

  augroup('LastPosJmp', {
    'BufReadPost',
    {
      pattern = "*",
      command =
      [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
      desc = "Return to last edit position when opening files",
    },
  })

  augroup('RemoveWitespace', {
    'BufWritePre',
    {
      pattern = "*",
      command = [[%s/\s\+$//e]],
      desc = "Remove whitespace",
    },
  })
end

-- ( Autocommand Terminal )
-------------------------------------------------------------------------------
local terminal = function()
  augroup('TerminalMode', {
    'TermOpen',
    {
      pattern = 'term://*',
      callback = vim.schedule_wrap(function(data)
        -- Try to start terminal mode only if target terminal is current
        if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
        vim.cmd('startinsert')
      end),
      desc = 'Start terminal mode ',
    },
  })
end

--  ( Autocommand Bigfile )
-------------------------------------------------------------------------------
local bigfile = function()
  augroup('Bigfile', {
    'BufReadPre',
    {
      desc = 'Handle Bigfile',
      callback = function(info)
        local stat = vim.uv.fs_stat(info.match)
        if not stat or stat.size <= 2 * 1024 * 1024 then return end -- 2MB

        local buf = info.buf
        vim.b[buf].bigfile = true

        vim.notify("Big file detected: disabling Treesitter, LSP, and heavy options", vim.log.levels.WARN)

        -- Disable expensive options
        vim.api.nvim_buf_call(buf, function()
          vim.opt_local.spell = false
          vim.opt_local.swapfile = false
          vim.opt_local.undofile = false
          vim.opt_local.breakindent = false
          vim.opt_local.foldmethod = "manual"
        end)

        -- Disable Treesitter highlight if active
        local ts = vim.treesitter
        if ts.highlighter.active[buf] then
          ts.stop(buf)
          vim.bo[buf].syntax = vim.filetype.match({ buf = buf }) or vim.bo[buf].bt
        end

        -- Override Treesitter and LSP attach
        local ts_parser = ts.get_parser
        ---@diagnostic disable-next-line: duplicate-set-field
        function ts.get_parser(b, ...)
          b = b == 0 and vim.api.nvim_get_current_buf() or b
          if b == buf then
            return ts._create_parser(
              vim.api.nvim_create_buf(false, true),
              ts.language.get_lang(vim.bo.ft) or vim.bo.ft
            )
          end
          return ts_parser(b, ...)
        end

        local lsp_start = vim.lsp.start
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.start(...)
          if vim.api.nvim_get_current_buf() == buf then return end
          return lsp_start(...)
        end

        local ts_fold = ts.foldexpr
        ---@diagnostic disable-next-line: duplicate-set-field
        function ts.foldexpr(...)
          if vim.api.nvim_get_current_buf() == buf then return end
          return ts_fold(...)
        end
      end,
    },
  })
end

-- ( Autocommand Autosave )
-------------------------------------------------------------------------------
local autosave = function()
  augroup('Autosave', {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      nested = true,
      desc = 'Autosave on focus change.',
      callback = function(info)
        -- Don't auto-save non-file buffers
        if (vim.uv.fs_stat(info.file) or {}).type ~= 'file' then
          return
        end
        vim.cmd.update({
          mods = { emsg_silent = true },
        })
      end,
    },
  })
end

-------------------------------------------------------------------------------
-- Netrw ======================================================================
-------------------------------------------------------------------------------
local netrw = function()
  local function netrw_mapping()
    local bufmap = function(lhs, rhs)
      local opts = { buffer = true, remap = true, nowait = true }
      vim.keymap.set('n', lhs, rhs, opts)
    end

    -- close window
    bufmap('q', ':bd<cr>')

    -- Go back in history
    bufmap('H', 'u')

    -- Go up a directory
    bufmap('h', '-^')

    -- Open file/directory
    bufmap('l', '<cr>')

    -- Toggle dotfiles
    bufmap('.', 'gh')
  end

  augroup('NetrwMap', {
    { 'FileType' },
    {
      pattern = 'netrw',
      desc = 'Keybindings for netrw',
      callback = netrw_mapping
    },
  })

  vim.keymap.set('n', '-', vim.cmd.Ex, {})
end
-------------------------------------------------------------------------------
-- Usercommands ================================================================
-------------------------------------------------------------------------------

-- Remove all buffers except the current one.
vim.api.nvim_create_user_command("BuffClean", function()
  local cur = vim.api.nvim_get_current_buf()

  local deleted, modified = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      modified = modified + 1
    elseif buf ~= cur and vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
      deleted = deleted + 1
    end
  end

  vim.notify(("%s deleted, %s modified"):format(deleted, modified), vim.log.levels.WARN, {})
end, {
  desc = "Remove all buffers except the current one.",
})

-- Create scratch buffer.
vim.api.nvim_create_user_command("Scratch", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, {
  desc = "New scratch buffer",
})

-- Open terminal in split with root directory.
vim.api.nvim_create_user_command("T", function()
  vim.cmd("belowright new")
  vim.fn.jobstart(vim.o.shell, {
    term = true,
  })
end, {
  desc = "Open terminal in split with root directory",
})

-- Open terminal in split with buffer's directory.
vim.api.nvim_create_user_command("BT", function()
  local term_dir = vim.fn.expand("%:p:h")
  vim.cmd("belowright new")
  vim.fn.jobstart(vim.o.shell, {
    cwd = term_dir,
    term = true,
  })
end, {
  desc = "Open terminal in split with buffer's directory",
})

-------------------------------------------------------------------------------
-- Zenmode ====================================================================
-------------------------------------------------------------------------------
local zenmode = function()
  local z = {}

  local function set_zen_options(enable)
    vim.o.signcolumn    = enable and "no" or "yes"
    vim.opt_local.spell = not enable
    vim.o.wrap          = enable
    vim.o.rnu           = not enable
    vim.o.nu            = not enable
    vim.o.cmdheight     = enable and 0 or 1
    vim.o.laststatus    = enable and 0 or 2
  end

  local function create_window(width, direction)
    vim.api.nvim_command("vsp")
    vim.api.nvim_command("wincmd " .. direction)
    pcall(vim.cmd, "buffer " .. z.buf)
    vim.api.nvim_win_set_width(0, width)

    vim.wo.winfixwidth = true
    vim.wo.cursorline  = false
    vim.wo.winfixbuf   = true
    vim.o.numberwidth  = 1
  end

  function z.zenmode(c)
    if z.buf == nil then
      z.buf = vim.api.nvim_create_buf(false, false)
      set_zen_options(true)

      local width = 54 --default width
      if #c.fargs == 1 then
        width = tonumber(c.fargs[1])
      end

      local cur_win = vim.fn.win_getid()
      create_window(width, "H")
      create_window(width, "L")
      vim.api.nvim_set_current_win(cur_win)
    else
      vim.api.nvim_buf_delete(z.buf, { force = true })
      z.buf = nil
      set_zen_options(false)
    end
  end

  vim.api.nvim_create_user_command("Zenmode", function(c)
    z.zenmode(c)
  end, { nargs = "?" })
end

-------------------------------------------------------------------------------
-- Grep =======================================================================
-------------------------------------------------------------------------------

local grep = function()
  if vim.fn.executable('rg') == 1 then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden'
    vim.o.grepformat = '%f:%l:%c:%m'
  end

  -- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
  -- without output or jumping to first match
  -- Use ':Grep <pattern> %' to search only current file
  -- Use ':Grep <pattern> %:h' to search the current file dir

  vim.cmd('command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen')
  vim.cmd('command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen')

  map.ca({
    ['grf'] = [[Grep <c-r><c-w> %<cr>]],
    ['Grf'] = [[LGrep <c-r><c-w> %<cr>]],
    ['grd'] = [[Grep <c-r><c-w> %:h<cr>]],
    ['Grd'] = [[LGrep <c-r><c-w> %:h<cr>]],
  })
end

-------------------------------------------------------------------------------
-- Helper =====================================================================
-------------------------------------------------------------------------------

local function is_enabled(flag)
  return flag == nil or flag == true
end

H.safe_for_each = function(list, fn)
  if type(list) == "table" and #list > 0 then
    for _, v in ipairs(list) do fn(v) end
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

-- Get visual selection text.
-- taken from: https://github.com/ibhagwan/nvim-lua/blob/f772c7b41ac4da6208d8ae233e1c471397833d64/lua/utils.lua#L96
H.get_visual_selection = function(nl_literal)
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "" then
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
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

  if n <= 0 then
    return ""
  end

  if n > 1 then
    return nil
  end

  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)

  return table.concat(lines, nl_literal and "\\n" or "\n")
end

-- FIXME: how to handle <>'s, etc.
local escape_characters = '"\\/.*$^~[]'

-- double escaping is required due to interpretation by feedkeys and then search/replace
H.double_escape = function(str)
  return vim.fn.escape(vim.fn.escape(str, escape_characters), escape_characters)
end

-- Helper substitute visual mode
H.visual_charwise_selection = function()
  local visual_selection = H.get_visual_selection()

  if visual_selection == nil then
    print("search-replace does not support visual-blockwise selections")
    return
  end

  local backspace_keypresses = string.rep("\\<backspace>", 5)
  local left_keypresses = string.rep("\\<Left>", 2)

  vim.cmd(
    ':call feedkeys(":'
    .. backspace_keypresses
    .. "%s/"
    .. H.double_escape(visual_selection)
    .. "/"
    .. H.double_escape(visual_selection)
    .. "/"
    .. "g"
    .. left_keypresses
    .. '")'
  )
end

-- ( Keymaps Helper )
-------------------------------------------------------------------------------
local function normalize_mode(mode)
  -- Daftar mode multi-karakter yang sah
  local valid_composite_modes = {
    ca = true,
    cn = true,
    cv = true,
    ce = true,
  }

  if type(mode) == 'string' then
    if #mode == 1 or valid_composite_modes[mode] then
      return mode
    end

    local modes = {}
    for i = 1, #mode do
      table.insert(modes, mode:sub(i, i))
    end
    return modes
  end
  return mode
end

local desc_cache_file = vim.fn.stdpath('cache') .. '/desc_cache.json'
local desc_cache = {}

-- Load if exists
local f = io.open(desc_cache_file, 'r')
if f then
  local content = f:read('*a')
  desc_cache = vim.fn.json_decode(content)
  f:close()
end

local function save_desc_cache()
  local f = io.open(desc_cache_file, 'w')
  if f then
    f:write(vim.fn.json_encode(desc_cache))
    f:close()
  end
end

local function extract_description(key, cmd)
  if type(cmd) ~= 'string' then return '' end
  if desc_cache[key] then return desc_cache[key] end
  -- delete prefix '!'
  cmd = cmd:gsub('^!', '')

  local lua_expr = cmd:match('^lua%s+(.*)')
  if lua_expr then
    local mod, fn = lua_expr:match('^([%w_%.]+)[%.:]([%w_]+)%s*%(')
    if mod and fn then
      return string.format("%s '%s'", mod, fn)
    else
      return lua_expr
    end
  end

  desc_cache[key] = cmd
  save_desc_cache()
  return cmd
end

local function parse_prefixed_rhs(key, value, default_opts)
  local opts = vim.tbl_extend('force', {
    silent = true,
    expr = false,
  }, default_opts or {})

  if type(value) ~= 'string' then return value, opts end

  -- Regex pattern: pisahkan prefix dan sisanya
  local flags, rhs = value:match('^([!~=]*)(.+)$')
  if not flags then return value, opts end

  -- Interpretasi flag
  if flags:find('!') then
    opts.desc = extract_description(key, rhs)
    rhs = '<cmd>' .. rhs .. '<CR>'
  end
  if flags:find('~') then opts.silent = false end
  if flags:find('=') then opts.expr = true end

  return rhs, opts
end

-- auto define dynamic method like map.ni(), map.xc(), map.nix()
H.map = setmetatable({}, {
  __index = function(t, mode)
    -- return function(lhs, rhs, opts)
    return function(arg1, arg2, arg3)
      arg3 = vim.tbl_extend('force', { noremap = true, silent = true }, arg3 or {})
      mode = normalize_mode(mode)

      if type(arg1) == 'table' then
        for key, value in pairs(arg1) do
          arg3 = vim.tbl_extend('force', (type(value) == 'string' and { desc = value } or {}), arg2 or {})
          value, arg3 = parse_prefixed_rhs(key, value, arg3)
          vim.keymap.set(mode, key, value, arg3)
        end
      else
        arg2, arg3 = parse_prefixed_rhs(arg1, arg2, arg3)
        vim.keymap.set(mode, arg1, arg2, arg3)
      end
    end
  end,
})

_G.map = H.map

-------------------------------------------------------------------------------
-- Feature Execution =================================================================
-------------------------------------------------------------------------------

local F = {
  options                   = options,
  grep                      = grep,
  toggle_options            = toggle_options,
  zenmode                   = zenmode,
  quickfix                  = quickfix,
  netrw                     = netrw,
  ["autocommands.basic"]    = autocommands,
  ["autocommands.terminal"] = terminal,
  ["autocommands.autosave"] = autosave,
  ["autocommands.bigfile"]  = bigfile,
  ["keymaps.basic"]         = basic_keymaps,
  ["keymaps.autoclose"]     = autoclose,
  ["keymaps.multi_cursors"] = multi_cursors,
  ["keymaps.substitute"]    = substitute,
  ["keymaps.window"]        = window,
  ["keymaps.readline"]      = readline,
}

for name, fn in pairs(F) do
  -- Akses nested table dengan split key (mis. "autocommands.basic")
  local parts = vim.split(name, ".", { plain = true })
  local config = H.Config.features
  for _, key in ipairs(parts) do
    config = config and config[key]
  end
  if is_enabled(config) then fn() end
end
