return {
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
}
