return {
  -- Text editing
  { module = 'mini.align', config = true }, -- See :help MiniAlign-examples
  { module = 'mini.comment', config = true },
  { module = 'mini.operators', opts = { sort = { prefix = 'gz' } } },
  { module = 'mini.move', opts = { options = { reindent_linewise = false } } },
  { module = 'mini.splitjoin', config = true },
  {
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
  },
  {
    module = 'mini.ai',
    opts = {},
    config = function()
      vim.keymap.set({ 'x', 'o' }, 'q', 'iq', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'Q', 'aq', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'w', 'iw', { remap = true })
      vim.keymap.set({ 'x', 'o' }, 'W', 'iW', { remap = true })
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

  -- General workflow
  { module = 'mini.git', config = true },
  { module = 'mini.misc', config = true },
  { module = 'mini.bracketed', config = true },
  { module = 'mini.extra', config = true },
  {
    module = 'mini.clue',
    config = function()
      local miniclue = require('mini.clue')

      -- Some builtin keymaps that I don't use and that I don't want mini.clue to show.
      for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
        vim.keymap.del('n', lhs)
      end

      miniclue.setup({
        triggers = {
          -- Custom.
          { mode = 'n', keys = 'q' },
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
          { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
          { mode = 'n', keys = '<Leader>l', desc = '+Lsp' },
          { mode = 'n', keys = '<Leader>c', desc = '+Code' },
          { mode = 'n', keys = '<Leader>p', desc = '+Picker' },
          { mode = 'n', keys = '[', desc = '+prev' },
          { mode = 'n', keys = ']', desc = '+next' },
        },

        window = {
          delay = 0,
          config = {
            anchor = 'SW',
            row = 'auto',
            col = 'auto',
          },
        },
      })
    end,
  },
  {
    module = 'mini.sessions',
    lazy = false,
    opts = {},
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

      vim.keymap.set('n', '<Leader>zs', actions.switch_session, { desc = 'Switch Session' })
      vim.keymap.set('n', '<Leader>zw', actions.write_session, { desc = 'Write Session' })
      vim.keymap.set('n', '<Leader>zl', actions.load_session, { desc = 'Load Session' })
      vim.keymap.set('n', '<Leader>zd', actions.delete_session, { desc = 'Delete Session' })
    end,
  },

  {
    module = 'mini.bufremove',
    opts = {},
    config = function()
      vim.keymap.set('n', '<Leader>Q', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Buf delete keep layout' })
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
    module = 'mini.jump',
    opts = { mappings = { repeat_jump = ',' } },
  },
  {
    module = 'mini.jump2d',
    opts = {
      allowed_lines = { blank = false, fold = false },
      allowed_windows = { not_current = false },
      mappings = { start_jumping = '' },
    },
    config = function()
      local jump2d = require('mini.jump2d')

      local noop = function() return {} end

      local function get_labels(dir)
        local cursor_line = vim.fn.line('w0')
        local last_line = vim.fn.line('w$')
        local cur_line = vim.api.nvim_win_get_cursor(0)[1]

        local lines_above = cur_line - cursor_line
        local lines_below = last_line - cur_line

        local chars = {}
        for c in ('123456789abcdefghijklmnopqrstuvwxyz'):gmatch('.') do
          table.insert(chars, c)
        end

        local reversed = {}
        for i = #chars, 1, -1 do
          table.insert(reversed, chars[i])
        end

        local first = string.sub(table.concat(reversed), -lines_above)
        local last = string.sub(table.concat(chars), 1, lines_below)

        return dir == 'up' and first or last
      end

      -- Jump line
      local function jump_line(dir)
        local opts = {
          allowed_lines = {
            blank = true,
            cursor_at = false,
            cursor_before = dir ~= 'down',
            cursor_after = dir == 'down',
          },
          spotter = jump2d.builtin_opts.line_start.spotter,
          hooks = {},
        }

        opts.hooks.before_start = function()
          opts.labels = get_labels(dir)
          vim.b.cursor_pre_line = vim.api.nvim_win_get_cursor(0)
        end

        opts.hooks.after_jump = function()
          local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
          local _, col = unpack(vim.b.cursor_pre_line)
          vim.api.nvim_win_set_cursor(0, { line, col })
          vim.b.cursor_pre_line = nil
        end

        return function() jump2d.start(opts) end
      end

      -- Jump word
      local function jump_word()
        local opts = { spotter = noop, hooks = {} }

        local function gen_word_start(char_pattern, upper)
          local camel_pat = ('[%%l]+%s'):format(upper)
          local camel = jump2d.gen_spotter.pattern(camel_pat, 'end')
          local word_start = jump2d.builtin_opts.word_start.spotter
          local char_spot = jump2d.gen_spotter.pattern(char_pattern)

          return jump2d.gen_spotter.union(function(num, args)
            local cs, ws, res = char_spot(num, args), word_start(num, args), {}
            if not cs or not ws then return {} end
            for _, i in ipairs(cs) do
              if vim.tbl_contains(ws, i) then res[#res + 1] = i end
            end
            return res
          end, camel)
        end

        opts.hooks.before_start = function()
          local ok, ch = pcall(vim.fn.getcharstr)
          if not ok or not ch then return end
          if ch:match('[a-z]') then
            local pattern = ('[%s%s]'):format(ch, ch:upper())
            opts.spotter = gen_word_start(pattern, ch:upper())
          elseif ch:match('[A-Z]') then
            opts.spotter = gen_word_start(ch, ch)
          else
            local pattern = ('[%s]'):format(vim.pesc(ch))
            opts.spotter = jump2d.gen_spotter.pattern(pattern)
          end
        end

        return function() jump2d.start(opts) end
      end

      vim.keymap.set('', 'H', jump_line('up'))
      vim.keymap.set('', 'L', jump_line('down'))
      vim.keymap.set('', 't', jump_word())

      vim.o.nu = false
      vim.o.relativenumber = false
    end,
  },

  -- Appearance
  { module = 'mini.indentscope', config = true },
  { module = 'mini.cursorword', config = true },
  { module = 'mini.icons', config = true },
  { module = 'mini.statusline', lazy = false, enable = false },
  { module = 'mini.tabline', lazy = false, enable = false },
  { module = 'mini.colors', lazy = false, enable = false },
  {
    module = 'mini.starter',
    lazy = false,
    config = function()
      local starter = require('mini.starter')
      -- See :help MiniStarter-example-config
      starter.sections.quick_access = function()
        return function()
          return {
            { action = 'FzfLua files', name = 'f. Files', section = 'Quick Access' },
            { action = 'FzfLua grep', name = 'g. Grep', section = 'Quick Access' },
            { action = 'FzfLua oldfiles', name = 'o. Old files', section = 'Quick Access' },
            { action = 'FzfLua helptags', name = 'h. Help tags', section = 'Quick Access' },
          }
        end
      end

      starter.setup({
        evaluate_single = true,
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

      vim.keymap.set('n', '<Leader>cc', '<Cmd>lua MiniHipatterns.toggle()<CR>', { desc = 'Colorizer' })
    end,
  },

  {
    module = 'mini.trailspace',
    opts = {},
    config = function()
      vim.keymap.set('n', '<Leader>ct', '<Cmd>lua MiniTrailspace.trim()<CR>', { desc = 'Trim Trailspace' })
    end,
  },
}
