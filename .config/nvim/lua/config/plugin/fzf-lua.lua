local fzf = require('fzf-lua')

-- See :help fzf-lua-customization
fzf.setup({
  'max-perf',
  winopts = {
    height = 0.59,
    width = 0.90,
    row = 0.48,
    col = 0.45,
    preview = {
      hidden = true,
      vertical = 'up:45%',
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
})

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

vim.api.nvim_create_user_command('F', function(info) fzf.files({ cwd = info.fargs[1] }) end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Fuzzy find files.',
})

function fzf.hl_word()
  local cmd =
    [[rg --color=never --column --line-number --no-heading --smart-case --max-columns=4096 -e '\b(TODO|FIXME|HACK|NOTE)\b']]

  require('fzf-lua').fzf_exec(cmd, {
    prompt = 'TODO|FIXME|HACK|NOTE❯ ',
    actions = fzf.defaults.files._actions,
    previewer = false,
    preview = {
      type = 'cmd',
      fn = function(items)
        local file, line_num, col, msg = items[1]:match('^(.-):(%d+):(%d+):(.*)$')

        line_num = tonumber(line_num)
        col = tonumber(col)

        local range = math.floor(vim.api.nvim_win_get_height(0) / 2.5)
        local start_line = math.max(1, line_num - range)
        local end_line = line_num + range + 1

        return string.format(
          'bat --style=numbers --color=always -r %d:%d -H %d %s',
          start_line,
          end_line,
          line_num,
          file
        )
      end,
    },
  })
end

-- FzfLua Bookmark -----------------------------------------------------------
local cdg_paths = os.getenv('HOME') .. '/.bookmarks'

function fzf.bookmark_dir()
  local prompt = 'Bookmark❯ '
  require('fzf-lua').fzf_exec('cat ' .. cdg_paths, {
    prompt = prompt,
    winopts = { height = 0.5, width = 0.5 },
    actions = {
      ['default'] = function(selected) vim.cmd('F ' .. selected[1]) end,
      ['alt-c'] = function(selected)
        vim.cmd('cd ' .. selected[1])
        vim.notify('cwd change to: ' .. selected[1])
      end,
    },
    fzf_opts = {
      ['--multi'] = '',
    },
  })
end

-- FzfLua Snippet -----------------------------------------------------------
local H = {}
H._snippet_cache = {}

H.load_snippets_file = function(path)
  if vim.fn.filereadable(path) ~= 1 then return nil end
  local content = vim.fn.readfile(path)
  local data = table.concat(content, '\n')
  local ok, decoded = pcall(vim.json.decode, data)
  if ok then return decoded end
  return nil
end

H.load_snippets = function(ft)
  local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets')

  local global = H.load_snippets_file(vim.fs.joinpath(dir, 'global.json')) or {}
  local local_ = H.load_snippets_file(vim.fs.joinpath(dir, ('%s.json'):format(ft))) or {}

  return vim.tbl_extend('force', global, local_)
end

H.fzf_use_snippets = function(ft, snippets)
  local entries, snippet_lookup = {}, {}

  for name, info in pairs(snippets) do
    local prefix = type(info.prefix) == 'table' and table.concat(info.prefix, ', ') or info.prefix
    local label = string.format('%s  [%s]', name, prefix)
    table.insert(entries, label)

    local single_prefix = type(info.prefix) == 'table' and info.prefix[1] or info.prefix
    snippet_lookup[label] = vim.tbl_extend('force', info, { name = name, prefix = single_prefix })
  end

  fzf.fzf_exec(entries, {
    prompt = 'Snippet❯ ',
    winopts = { height = 0.5, width = 0.5 },
    actions = {
      ['default'] = function(selected)
        local choice = selected[1]
        local snippet = snippet_lookup[choice]
        if snippet then
          local body = type(snippet.body) == 'table' and table.concat(snippet.body, '\n') or snippet.body
          vim.snippet.expand(body)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>i', true, true, true), 'n', true)
        else
          vim.notify('Snippet not found', vim.log.levels.WARN)
        end
      end,
    },
  })
end

function fzf.snippets()
  local ft = vim.bo.filetype

  if H._snippet_cache[ft] then return H.fzf_use_snippets(ft, H._snippet_cache[ft]) end

  local snippets = H.load_snippets(ft)

  if not snippets or vim.tbl_isempty(snippets) then
    vim.notify('No snippets found for filetype: ' .. ft, vim.log.levels.INFO)
    return
  end

  H._snippet_cache[ft] = snippets
  H.fzf_use_snippets(ft, snippets)
end

-- FzfLua MRU -----------------------------------------------------------------
function fzf.mru()
  local show_all = false
  local home = vim.fn.expand('~')
  local cwd = vim.loop.cwd()
  local prompt = 'MRU '
  prompt = prompt .. cwd

  local function show_fzf(files)
    local previewer = fzf.defaults.files.previewer
    local base_actions = fzf.defaults.files._actions()

    local actions = vim.tbl_extend('keep', {
      ['ctrl-space'] = function()
        show_all = not show_all
        if show_all then
          prompt = 'MRU ' .. home
          show_fzf(MRU.get())
          show_all = true
        else
          prompt = 'MRU ' .. cwd
          show_fzf(MRU.get({ scope = 'cwd' }))
        end
      end,
    }, base_actions or {})

    require('fzf-lua').fzf_exec(files, {
      previewer = previewer,
      actions = actions,
      prompt = prompt .. '> ',
    })
  end

  show_fzf(MRU.get({ scope = 'cwd' }))
end

-- custom fzf
local custom = {
  config = function() fzf.files({ cwd = vim.fn.stdpath('config') }) end,
  bcword = function() fzf.blines({ start = 'cursor', query = vim.fn.expand('<cword>') }) end,
  diagnostics = function(opts)
    return fzf.diagnostics_workspace(vim.tbl_extend('force', opts or {}, {
      prompt = 'Workspace Diagnostics> ',
    }))
  end,
  help = function()
    local ok = pcall(vim.cmd.help, vim.fn.expand('<cWORD>'))
    if not ok then fzf.help_tags({ query = vim.fn.expand('<cword>') }) end
  end,
}

local Fzf = vim.tbl_deep_extend('force', vim.deepcopy(require('fzf-lua')), custom)

-- <Leader>p for picker
-- stylua: ignore start
vim.keymap.set('n', 'z=',         Fzf.spell_suggest,   { desc = 'Spell suggest' })
vim.keymap.set('n', '<Leader>?',  Fzf.help,            { desc = 'Nvim help' })
vim.keymap.set('n', '<Leader>8',  Fzf.bcword,          { desc = 'Buffer word' })
vim.keymap.set('n', '<Leader>f',  Fzf.files,           { desc = 'Files' })
vim.keymap.set('n', '<Leader>h',  Fzf.mru,             { desc = 'Mru' })
vim.keymap.set('n', '<Leader>F',  Fzf.git_files,       { desc = 'Gitfiles' })
vim.keymap.set('v', '<Leader>ps', Fzf.grep_visual,     { desc = 'Search visual' })
vim.keymap.set('n', '<Leader>ps', Fzf.grep_cword,      { desc = 'Search word' })
vim.keymap.set('n', '<Leader>pi', Fzf.grep,            { desc = 'Search input' })
vim.keymap.set('n', '<Leader>ph', Fzf.oldfiles,        { desc = 'Oldfiles' })
vim.keymap.set('n', '<Leader>pb', Fzf.buffers,         { desc = 'Buffer' })
vim.keymap.set('n', '<Leader>pd', Fzf.diagnostics,     { desc = 'Diagnostics' })
vim.keymap.set('n', '<Leader>pr', Fzf.resume,          { desc = 'Resume' })
vim.keymap.set('n', '<Leader>p;', Fzf.command_history, { desc = 'Command history' })
vim.keymap.set('n', '<Leader>p/', Fzf.search_history,  { desc = 'Search history' })
vim.keymap.set('n', '<Leader>pn', Fzf.hl_word,         { desc = 'Hl word' })
vim.keymap.set('n', '<Leader>pc', Fzf.config,          { desc = 'Nvim config' })
vim.keymap.set('i', '<C-x><C-f>', Fzf.complete_path,   { desc = 'Complete path' })
vim.keymap.set('i', '<C-x><C-l>', Fzf.complete_line,   { desc = 'Complete line' })
-- stylua: ignore end
