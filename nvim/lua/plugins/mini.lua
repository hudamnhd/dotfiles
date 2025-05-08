local M = {
  "echasnovski/mini.nvim",
  version = "*",
  enabled = true,
  event = "VimEnter",
}

function M.config()
  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()
  require('mini.icons').tweak_lsp_kind()
  require("mini.operators").setup()
  require("mini.splitjoin").setup()
  require("mini.comment").setup()
  require("mini.extra").setup()
  require("mini.bracketed").setup()
  require("mini.basics").setup()
  require("mini.ai").setup()
  require("mini.tabline").setup()
  require("mini.tabline").setup()
  require("mini.bufremove").setup()
  require("mini.git").setup()

  local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
  bind('n', '<space>gw', '<Cmd>Git add %<CR>',                           { desc = 'Stage current file' })
  bind('n', '<space>gp', '<Cmd>Git push<CR>',                            { desc = 'Push' })
  bind('n', '<space>gf', '<Cmd>Git pull<CR>',                            { desc = 'Pull' })
  bind('n', '<space>ga', '<Cmd>Git diff --cached<CR>',                   { desc = 'Added diff' })
  bind('n', '<space>gA', '<Cmd>Git diff --cached -- %<CR>',              { desc = 'Added diff buffer' })
  bind('n', '<space>gc', '<Cmd>Git commit<CR>',                          { desc = 'Commit' })
  bind('n', '<space>gC', '<Cmd>Git commit --amend<CR>',                  { desc = 'Commit amend' })
  bind('n', '<space>gd', '<Cmd>Git diff<CR>',                            { desc = 'Diff' })
  bind('n', '<space>gD', '<Cmd>Git diff -- %<CR>',                       { desc = 'Diff buffer' })
  bind('n', '<space>gg', '<Cmd>lua _G.open_gitui()<CR>',                 { desc = 'Git tab' })
  bind('n', '<space>gl', '<Cmd>' .. git_log_cmd .. '<CR>',               { desc = 'Log' })
  bind('n', '<space>gL', '<Cmd>' .. git_log_cmd .. ' --follow -- %<CR>', { desc = 'Log buffer' })
  bind('n', '<space>go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>',       { desc = 'Toggle overlay' })
  bind('n', '<space>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',        { desc = 'Show at cursor' })
  bind('x', '<space>gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',        { desc = 'Show at selection' })

  local process_items = function(items, base)
    -- Don't show 'Text' suggestions
    items = vim.tbl_filter(function(x) return x.kind ~= 1 end, items)
    return require('mini.completion').default_process_items(items, base)
  end
  -- See :help MiniCompletion.config
  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false, process_items = process_items },
  })

  -- Set up LSP part of completion
  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })

  local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true })
  end
  imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
  imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

  local keycode = vim.keycode or function(x)
    return vim.api.nvim_replace_termcodes(x, true, true, true)
  end
  local keys = {
    ['cr']        = keycode('<CR>'),
    ['ctrl-y']    = keycode('<C-y>'),
    ['ctrl-y_cr'] = keycode('<C-y><CR>'),
  }

  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    else
      -- If popup is not visible, use plain `<CR>`. You might want to customize
      -- according to other plugins. For example, to use 'mini.pairs', replace
      -- next line with `return require('mini.pairs').cr()`
      return keys['cr']
    end
  end

  vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

  require("mini.align").setup(
    {
      mappings = {
        start = 'sga',
        start_with_preview = 'sgA',
      },
    }
  )

  require("mini.move").setup({
    options = {
      reindent_linewise = false,
    },
  })

  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    mappings = {
      ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
      [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
    },
  })

  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  })

  local hipatterns = require("mini.hipatterns")

  -- See :help MiniHipatterns.config
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  local miniclue = require("mini.clue")

  -- See :help MiniClue.config
  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<space>' },
      { mode = 'x', keys = '<space>' },
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = 's' },
      { mode = 'x', keys = 's' },
      { mode = 'n', keys = [[\]] },
      { mode = 'x', keys = [[\]] },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
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


  local predicate = function(notif)
    -- Only show LSP progress notifications
    return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
  end
  local custom_sort = function(notif_arr) return require("mini.notify").default_sort(vim.tbl_filter(predicate, notif_arr)) end

  -- See :help MiniNotify.config
  require('mini.notify').setup({ content = { sort = custom_sort } })
  vim.notify = require("mini.notify").make_notify()

  require("mini.surround").setup({
    mappings = {
      add = "ys",
      delete = "ds",
      find = "",
      find_left = "",
      highlight = "",
      replace = "cs",
      update_n_lines = "",
    },
  })

  -- Remap adding surrounding to Visual mode selection
  --stylua: ignore
  vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]],
    { silent = true, desc = "MiniSurround add visual" })

  -- unmap config generated `ys` mapping, prevents visual mode yank delay
  if vim.keymap then
    vim.keymap.del("x", "ys")
  else
    vim.cmd("xunmap ys")
  end

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set("n", "yss", "ys_", { remap = true })


  local mini_statusline = require('mini.statusline')

  local function statusline()
    local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
    local diagnostics = mini_statusline.section_diagnostics({ trunc_width = 75 })
    local lsp = mini_statusline.section_lsp({ icon = 'LSP', trunc_width = 75 })
    local filename = mini_statusline.section_filename({ trunc_width = 140 })
    local percent = '%2p%%'
    local location = '%3l:%-2c'

    return mini_statusline.combine_groups({
      { hl = mode_hl,                 strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { diagnostics, lsp } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFilename', strings = { '%{&filetype}' } },
      { hl = 'MiniStatuslineFileinfo', strings = { percent } },
      { hl = mode_hl,                  strings = { location } },
    })
  end

  -- See :help MiniStatusline.config
  mini_statusline.setup({
    content = { active = statusline },

    set_vim_settings = false,
  })
end

return M
