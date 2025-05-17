local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = 'mini.nvim', checkout = 'HEAD' })

-- Step one ===================================================================

now(
  function()
    require('mini.basics').setup({
      options = {
        basic = false,
      },
      mappings = {
        basic = false,
      },
      autocommands = {
        basic = false,
      },
    })
  end
)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

-- now(function()
--   local predicate = function(notif)
--     if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
--     -- Filter out some LSP progress notifications from 'lua_ls'
--     return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
--   end
--   local custom_sort = function(notif_arr) return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr)) end
--
--   require('mini.notify').setup({ content = { sort = custom_sort } })
--   vim.notify = MiniNotify.make_notify()
-- end)

now(function()
  require('mini.sessions').setup({
    autowrite = true,
  })
end)
now(function() require('mini.starter').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)

-- Step two ===================================================================
later(function() require('mini.colors').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.bufremove').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.move').setup({ options = { reindent_linewise = false } }) end)

later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    spotter = jump2d.gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
  })

  -- vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { reverse = true })
  vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { link = 'PMenuSel' })
  --
end)

later(
  function()
    require('mini.pairs').setup({
      modes = { insert = true, command = false, terminal = true },
      mappings = {
        ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
        ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
      },
    })
  end
)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },
  })
end)

later(function()
  require('mini.diff').setup()
  local rhs = function() return MiniDiff.operator('yank') .. 'gh' end
  vim.keymap.set('n', 'ghy', rhs, { expr = true, remap = true, desc = "Copy hunk's reference lines" })
end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  local map_multistep = require('mini.keymap').map_multistep
  map_multistep('i', '<Tab>', { 'pmenu_next' })
  map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  map_multistep('i', '<BS>', { 'minipairs_bs' })
end)

later(function()
  require('mini.misc').setup({ make_global = { 'put', 'put_text', 'stat_summary', 'bench_time' } })
  -- MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
end)

later(function()
  local remap = function(mode, lhs_from, lhs_to)
    local keymap = vim.fn.maparg(lhs_from, mode, false, true)
    local rhs = keymap.callback or keymap.rhs
    if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
    vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
  end
  remap('n', 'gx', 'gX')
  remap('x', 'gx', 'gX')

  require('mini.operators').setup()
end)

later(function()
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

  -- Remap adding surrounding to Visual mode selection
  --stylua: ignore
  vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]],
    { silent = true, desc = "MiniSurround add visual" })

  -- unmap config generated `ys` mapping, prevents visual mode yank delay
  if vim.keymap then
    vim.keymap.del('x', 'ys')
  else
    vim.cmd('xunmap ys')
  end

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set('n', 'yss', 'ys_', { remap = true })
end)

later(function()
  local miniclue = require('mini.clue')
  --stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = 's' }, -- Leader triggers
      { mode = 'x', keys = 's' }, -- Leader triggers
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = 'g' },        -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'n', keys = 'z' },        -- `z` key
      { mode = 'x', keys = 'z' },
    },
    window = {
      delay = 0,
      config = {
        border = 'single',
        anchor = 'SW',
        width = 'auto',
        row = 'auto',
        col = 'auto',
      },
    },
  })
end)
