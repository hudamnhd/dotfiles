_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>s', desc = '+Sessions' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
}

local map = NvimConfig.map
local cmd = function(command) return '<cmd>' .. command .. '<cr>' end

-- Buffer
map.n({
  ['<space>`'] = cmd('Scrath'),
  ['<space>Z'] = cmd('BuffClean'),
  ['<space>c'] = cmd('lua MiniBufremove.delete()'),
  ['<space>C'] = cmd('lua MiniBufremove.wipeout()'),
  ['<s-h>'] = cmd("lua MiniBracketed.buffer('backward')"),
  ['<s-l>'] = cmd("lua MiniBracketed.buffer('forward')"),
  ['<c-s-h>'] = cmd("lua MiniBracketed.buffer('first')"),
  ['<c-s-l>'] = cmd("lua MiniBracketed.buffer('last')"),
})

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

map.n('yr', function()
  vim.cmd('vnew')
  vim.cmd('setlocal nonumber signcolumn=no')

  local job_id =
    vim.fn.jobstart('glow -s ~/.config/nvim/styles/custom.json ~/.config/nvim/regex_cheatsheet_nvim.md\n', {
      term = true,
      on_stdout = function(_, data) -- Opsi jika perlu menangani stdout
        -- Bisa menangani data output di sini
      end,
    })

  vim.defer_fn(function() vim.cmd.stopinsert() end, 10)
end)

map.n({
  ['<F4>'] = cmd('Zenmode'),
  ['<F5>'] = cmd('vert Git'),
})
