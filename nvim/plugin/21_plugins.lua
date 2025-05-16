local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

-- Tree-sitter (advanced syntax parsing, highlighting, textobjects) ===========
now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add('nvim-treesitter/nvim-treesitter-textobjects')

  --stylua: ignore
  local ensure_installed = {
    -- 'bash',       'c',     'cpp',   'css',  'html',
    -- 'javascript', 'json',  'julia', 'php',  'python',
    -- 'r',          'regex', 'rst',   'rust', 'toml', 'tsx', 'yaml',
  }

  require('nvim-treesitter.configs').setup({
    ensure_installed = ensure_installed,
    highlight = { enable = true },
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = false },
  })

  -- Disable injections in 'lua' language
  local ts_query = require('vim.treesitter.query')
  local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
  ts_query_set('lua', 'injections', '')
end)

-- Lsp configurations =========================================================
later(function()
  -- Enable LSP only on Neovim>=0.11 as it introduced `vim.lsp.config`
  if vim.fn.has('nvim-0.11') == 0 then return end

  add('neovim/nvim-lspconfig')

  -- All language servers are expected to be installed with 'mason.vnim'
  vim.lsp.enable({
    'lua_ls',
    'ts_ls',
  })
end)

-- Filetype: csv ==============================================================
later(function()
  vim.g.disable_rainbow_csv_autodetect = true
  add('mechatroner/rainbow_csv')
end)

-- Helper ==============================================================

-- Edit text in the quickfix win
later(function() add('stefandtw/quickfix-reflector.vim') end)

-- Completion/formatting/linter ===================================================================
later(function()
  add('nvimdev/phoenix.nvim')
  local api = vim.api
  local au = api.nvim_create_autocmd

  au('LspAttach', {
    group = api.nvim_create_augroup('phoenix.completion', { clear = true }),
    callback = function(args)
      local lsp = vim.lsp
      local completion = lsp.completion
      local ms = lsp.protocol.Methods

      local bufnr = args.buf
      local client = lsp.get_client_by_id(args.data.client_id)
      if not client or not client:supports_method(ms.textDocument_completion) then return end
      local chars = client.server_capabilities.completionProvider.triggerCharacters
      if chars then
        for i = string.byte('a'), string.byte('z') do
          if not vim.list_contains(chars, string.char(i)) then table.insert(chars, string.char(i)) end
        end

        for i = string.byte('A'), string.byte('Z') do
          if not vim.list_contains(chars, string.char(i)) then table.insert(chars, string.char(i)) end
        end
      end

      completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          local kind = lsp.protocol.CompletionItemKind[item.kind] or 'u'
          return {
            abbr = item.label:gsub('%b()', ''),
            kind = kind,
            menu = '',
          }
        end,
      })

      au('CompleteChanged', {
        buffer = bufnr,
        callback = function()
          local info = vim.fn.complete_info({ 'selected' })
          if info.preview_bufnr and vim.bo[info.preview_bufnr].filetype == '' then
            vim.bo[info.preview_bufnr].filetype = 'markdown'
            vim.wo[info.preview_winid].conceallevel = 2
            vim.wo[info.preview_winid].concealcursor = 'niv'
          end
        end,
      })
    end,
  })
end)
later(function()
  add('nvimdev/guard.nvim')
  add('nvimdev/guard-collection')
  local ft = require('guard.filetype')
  ft('lua'):fmt('stylua')
  ft('javascript, markdown, css, typescript, javascriptreact, typescriptreact, scss, html,  yaml, astro')
    :fmt('dprint')
    :fmt('biome')
  ft('json, json5, jsonc'):fmt('biome')
end)

-- Filetype: oil ==============================================================
later(function() add('stevearc/oil.nvim') end)

later(function()
  local opts = {
    columns = {
      'size',
    },
    delete_to_trash = true,
    keymaps = {
      ['h'] = { 'actions.parent', mode = 'n', desc = 'parent' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['l'] = { 'actions.select', mode = 'n', desc = 'select' },
      ['gd'] = {
        desc = 'Toggle detail view',
        callback = function()
          local oil = require('oil')
          local config = require('oil.config')
          if #config.columns == 1 then
            oil.set_columns({ 'size', 'permissions', 'mtime', 'icon' })
          else
            oil.set_columns({ 'size' })
          end
        end,
      },
      ['Y'] = {
        -- source: https://www.reddit.com/r/neovim/comments/1czp9zr/comment/l5hv900/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        desc = 'Copy filepath to system clipboard',
        callback = function()
          require('oil.actions').copy_entry_path.callback()
          local copied = vim.fn.getreg(vim.v.register)
          vim.fn.setreg('+', copied)
          vim.notify('Copied to system clipboard:\n' .. copied, vim.log.levels.INFO, {})
        end,
      },
    },
  }
  require('oil').setup(opts)
end)

-- Picker =====================================================================
later(function()
  if vim.fn.executable('fzf') == 0 then return end
  add('ibhagwan/fzf-lua')
  local fzf = require('fzf-lua')

  -- local lines = {}
  -- for k, v in pairs(_G) do
  --   table.insert(lines, string.format('%s = %s', k, vim.inspect(v)))
  -- end
  -- vim.fn.setqflist(vim.tbl_map(function(l) return { text = l } end, lines))
  -- vim.cmd('copen')
  --
  fzf.setup({
    'max-perf',
    winopts = {
      fullscreen = false,
      preview = {
        wrap = false,
        vertical = 'up:45%', -- up|down:size
        layout = 'vertical',
      },
    },
    lsp = { symbols = { symbol_style = 3 } },
  })

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

  -------------------------------------------------------------------------------
  -- FzfLua Lsp Cmd =============================================================
  -------------------------------------------------------------------------------
  local function transform_label(str)
    -- Match group helper
    local function match_and_format(pattern, label)
      local matched = str:match(pattern)
      if matched then return string.format("%s '%s'", label, matched) end
    end

    -- Known patterns
    local patterns = {
      { [[^FzfLua%.lsp_(.+)]], 'Lsp' },
      { [[^vim%.lsp%.(.+)]], 'Lsp' },
      { [[^FzfLua%.(.+)]], 'FzfLua' },
      { [[^vim%.(.+)]], 'Vim' },
    }

    for _, pat in ipairs(patterns) do
      local result = match_and_format(pat[1], pat[2])
      if result then return result end
    end

    -- Default: split PascalCase → spaced words
    local words = str:gsub('(%u)(%l+)', ' %1%2'):gsub('(%u)(%u%l)', ' %1%2')

    return vim.trim(words)
  end

  local function is_typescript_tools_active()
    for _, client in pairs(vim.lsp.get_clients()) do
      if client.name == 'typescript-tools' then return true end
    end
    return false
  end

  local lsp_cmds = {
    'FzfLua.diagnostics_workspace',
    'FzfLua.diagnostics_document',
  }

  local lsp_attach = function()
    local function reverse_list(list)
      local reversed = {}
      for i = #list, 1, -1 do
        table.insert(reversed, list[i])
      end
      return reversed
    end

    local fzf_lsp = {
      'FzfLua.lsp_document_symbols',
      'FzfLua.lsp_live_workspace_symbols',
      'FzfLua.lsp_definitions',
      'FzfLua.lsp_definitions',
      'FzfLua.lsp_typedefs',
      'FzfLua.lsp_implementations',
      'FzfLua.lsp_incoming_calls',
      'FzfLua.lsp_outgoing_calls',
      'FzfLua.lsp_references',
      'FzfLua.lsp_finder',
      'FzfLua.lsp_code_actions',
      'vim.lsp.buf.rename',
    }

    local ts_tools = {
      'TSToolsOrganizeImports',
      'TSToolsSortImports',
      'TSToolsRemoveUnusedImports',
      'TSToolsRemoveUnused',
      'TSToolsAddMissingImports',
      'TSToolsFixAll',
      'TSToolsGoToSourceDefinition',
      'TSToolsRenameFile',
      'TSToolsFileReferences',
    }

    local merged = vim.tbl_extend('force', {}, lsp_cmds)
    vim.list_extend(merged, fzf_lsp)

    if is_typescript_tools_active() then vim.list_extend(merged, ts_tools) end

    merged = reverse_list(merged)
    function fzf.lsp()
      vim.ui.select(merged, {
        prompt = 'Lsp Menu:',
        format_item = function(item) return transform_label(item) end,
      }, function(choice)
        if choice then vim.cmd(string.format('lua %s()', choice)) end
      end)
    end
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('FzfLuaLspAttachGroup', { clear = true }),
    callback = lsp_attach,
  })

  -------------------------------------------------------------------------------
  -- FzfLua MRU =============================================================
  -------------------------------------------------------------------------------
  local api, uv = vim.api, vim.loop

  function fzf.mru()
    local current
    if api.nvim_get_option_value('buftype', { buf = 0 }) == '' then
      current = uv.fs_realpath(api.nvim_buf_get_name(0))
    end

    local files_all = {}
    local files_cwd = {}
    local cwd = vim.fn.expand(vim.uv.cwd())
    local show_all = false

    local mru_files = MRU.get()

    for _, file in ipairs(mru_files) do
      if file ~= current then table.insert(files_all, file) end
    end

    local function update_files_cwd()
      files_cwd = {}
      for _, file in ipairs(files_all) do
        local file_absolute_path = vim.fn.fnamemodify(file, ':p')
        if vim.fn.stridx(file_absolute_path, cwd) == 0 then
          local relative_path = vim.fn.fnamemodify(file_absolute_path, ':.')
          table.insert(files_cwd, relative_path)
        end
      end
    end

    update_files_cwd()

    local prompt = 'MRU'
    prompt = prompt .. ' CWD'

    local function show_fzf(files)
      require('fzf-lua').fzf_exec(files, {
        actions = {
          ['default'] = require('fzf-lua').actions.file_edit,
          ['ctrl-space'] = function()
            show_all = not show_all
            if show_all then
              prompt = 'MRU ALL'
              show_fzf(files_all)
            else
              prompt = 'MRU CWD'
              update_files_cwd()
              show_fzf(files_cwd)
            end
          end,
        },
        fzf_opts = {
          ['--multi'] = '',
        },
        winopts = { height = 0.5, width = 0.5 },
        prompt = prompt .. '> ',
      })
    end

    show_fzf(files_cwd)
  end

  -------------------------------------------------------------------------------
  -- FzfLua Bookmark =============================================================
  -------------------------------------------------------------------------------
  local cdg_paths = os.getenv('HOME') .. '/.cdg_paths'

  function fzf.bookmark_dir()
    local prompt = 'DIR'
    prompt = prompt .. ' CWD'
    require('fzf-lua').fzf_exec('cat ' .. cdg_paths, {
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

  local bookmark_cmds = {
    "FzfLua.files({ cwd = '~/dot' })",
    "FzfLua.files({ cwd = '~/projects' })",
    "FzfLua.files({ cwd = '~/.config/nvim' })",
    'vim.cmd.vsplit(cdg_paths)',
    'FzfLua.bookmark_dir()',
  }

  function fzf.bookmark()
    vim.ui.select(bookmark_cmds, {
      prompt = 'Bookmark Menu:',
      format_item = function(item) return transform_label(item) end,
    }, function(choice)
      if choice then vim.cmd(string.format('lua %s', choice)) end
    end)
  end

  -------------------------------------------------------------------------------
  -- FzfLua Snippet =============================================================
  -------------------------------------------------------------------------------
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
      prompt = 'Select Snippet> ',
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
end)

-- Debug Print ==============================================================
later(function()
  add('andrewferrier/debugprint.nvim')

  require('debugprint').setup({
    keymaps = {
      normal = {
        plain_below = '<c-g>p',
        plain_above = '<c-g>P',
        variable_below = '<c-g>v',
        variable_above = '<c-g>V',
        variable_below_alwaysprompt = '',
        variable_above_alwaysprompt = '',
        textobj_below = '<c-g>o',
        textobj_above = '<c-g>O',
        toggle_comment_debug_prints = '',
        delete_debug_prints = '',
      },
      insert = {
        plain = '<C-G>p',
        variable = '<C-G>v',
      },
      visual = {
        variable_below = '<c-g>v',
        variable_above = '<c-g>V',
      },
    },
    commands = {
      toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
      delete_debug_prints = 'DeleteDebugPrints',
      reset_debug_prints_counter = 'ResetDebugPrintsCounter',
    },
    -- … Other options
  })
end)

-- Motion ==========================================================================
later(function()
  add('haya14busa/vim-edgemotion')

  -- Edgemotion
  vim.keymap.set('', '<c-j>', '<Plug>(edgemotion-j)', {})
  vim.keymap.set('', '<c-k>', '<Plug>(edgemotion-k)', {})
end)

-- Fugitive ========================================================================
later(function()
  add('tpope/vim-fugitive')

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
  augroup('FugitiveSettings', {
    'BufEnter',
    {
      desc = 'Ensure that fugitive buffers are not listed and are wiped out after hidden.',
      pattern = 'fugitive://*',
      callback = function(info)
        vim.bo[info.buf].buflisted = false

        vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true })

        vim.keymap.set(
          'n',
          '<space>p',
          function() vim.cmd.Git('push') end,
          { desc = 'Git push', buffer = true, nowait = true }
        )

        vim.keymap.set('n', '<space>f', function() vim.cmd.Git('pull') end, { desc = 'Git pull', buffer = true })

        -- rebase always
        vim.keymap.set(
          'n',
          '<space>r',
          function() vim.cmd.Git({ 'pull', '--rebase' }) end,
          { desc = 'Git pull --rebase', buffer = true }
        )

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set('n', '<space>P', ':Git push -u origin ', { desc = 'Git push origin', buffer = true })
      end,
    },
  }, {
    'FileType',
    {
      desc = 'Set buffer-local options for fugitive buffers.',
      pattern = 'fugitive',
      callback = function()
        vim.opt_local.winbar = nil
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    },
  }, {
    'FileType',
    {
      desc = 'Set buffer-local options for fugitive blame buffers.',
      pattern = 'fugitiveblame',
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.relativenumber = false
      end,
    },
  })
end)
