_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Space>g', desc = '+Git' },
  { mode = 'n', keys = 's',        desc = '+Fzf' },
}

map.ca({
  ['w'] = [[w<cr>]],
  ['q'] = [[q<cr>]],
  ['bd'] = [[bd<cr>]],
  ['fb'] = [[lua FzfLua.builtin()<cr>]],
  ['is'] = [[lua Config.insert_section()<cr>]],
  ['th'] = [[TSBufToggle highlight<cr>]],
})

-- Basic mappings =============================================================
-- Paste before/after linewise
local cmd = vim.fn.has('nvim-0.12') == 1 and 'iput' or 'put'
map.nx({
  ['[p'] = '<Cmd>exe "' .. cmd .. '! " . v:register<CR>',
  [']p'] = '<Cmd>exe "' .. cmd .. ' "  . v:register<CR>',
})

map.xo({
  ['q'] = [[iq]],
  ['Q'] = [[aq]],
  ['w'] = [[iw]],
  ['W'] = [[iW]],
  ['t'] = [[it]],
  ['T'] = [[at]],
}, { remap = true })

-- Edgemotion
map.nvo('<c-j>', '<Plug>(edgemotion-j)', {})
map.nvo('<c-k>', '<Plug>(edgemotion-k)', {})

-- EasyAlign
map.n('ga', '<Plug>(EasyAlign)', { desc = "EasyAlign" })
map.x('ga', '<Plug>(EasyAlign)', { desc = "EasyAlign" })

-- MiniOperator , MiniSurround
map.n({
  ['X'] = [[gxiw]],
  ['M'] = [[gmm]],
  ['S'] = [[ysiw]],
}, { remap = true })

map.n({
  ['<a-n>'] = [[!Scratch]],
  ['<space>x'] = [[!lua MiniBufremove.delete()]],
  ['<space>X'] = [[!lua MiniBufremove.wipeout()]],
  ['<space>q'] = [[!lua Config.toggle_qf('q')]],
  ['<space>Q'] = [[!lua Config.toggle_qf('l')]],
  ['<space>%'] = [[!lua Config.set_cwd()]],
  ['<space>$'] = [[!lua MiniSessions.select()]],
  ['<space>-'] = [[!lua Config.insert_section()]],
})

map.c({
  ['<F1>'] = [[\(.*\)<Left><Left>]],
  ['<c-v>'] = [[<C-R>"]],
  ['<a-v>'] = [[<C-R>+]],
})

map.t({
  ['<c-\\>'] = [[<C-\><C-n>]],
  ['<a-r>'] = [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
})

map.i({
  ['<c-x><c-f>'] = [[!lua FzfLua.complete_path()]],
  ['<c-x><c-l>'] = [[!lua FzfLua.complete_line()]],
})
map.x({
  ['sk'] = [[!lua FzfLua.grep_visual()]],
})
map.n({
  ['<c-b>'] = [[!lua FzfLua.buffers()]],
  ['<c-]>'] = [[!lua FzfLua.builtin()]],
  ['s0'] = [[!lua FzfLua.command_history()]],
  ['sf'] = [[!lua FzfLua.git_files()]],
  ['sh'] = [[!lua FzfLua.search_history()]],
  ['si'] = [[!lua FzfLua.grep()]],
  ['sj'] = [[!lua FzfLua.lgrep_curbuf()]],
  ['sk'] = [[!lua FzfLua.grep_cword()]],
  ['sl'] = [[!lua FzfLua.lsp()]],
  ['sm'] = [[!lua FzfLua.bookmark()]],
  ['sn'] = [[!lua FzfLua.snippets()]],
  ['so'] = [[!lua FzfLua.mru()]],
  ['sp'] = [[!lua FzfLua.files()]],
  ['sr'] = [[!lua FzfLua.live_grep_resume()]],
  ['ss'] = [[!lua FzfLua.resume()]],
  ['z='] = [[!lua FzfLua.spell_suggest()]],
})

-- g is for git
map.n({
  ['<space>go'] = [[!lua MiniDiff.toggle_overlay()]],
  ['<space>ga'] = [[!Gwrite]],
  ['<space>gr'] = [[!Gread]],
  ['<space>gd'] = [[!Gvdiffsplit]],
  ['<Space>gd'] = [[!Gdiff]],
  ['<Space>gD'] = [[!Git diff]],
  ['<Space>gB'] = [[!Git blame]],
  ['<Space>gl'] = [[!Git log --oneline --follow -- %]],
  ['<Space>gL'] = [[!Git log --oneline --graph]],
})

map.n({
  ['<F4>'] = [[!Zenmode]],
  ['<F5>'] = [[!vert Git]],
})

map.n('yd', function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  local n_diags = #diags
  if n_diags == 0 then
    vim.notify(
      '[LSP] no diagnostics found in current line',
      vim.log.levels.WARN
    )
    return
  end

  ---@param msg string
  local function _yank(msg)
    vim.fn.setreg('"', msg)
    vim.fn.setreg(vim.v.register, msg)
  end

  if n_diags == 1 then
    local msg = diags[1].message
    _yank(msg)
    vim.notify(
      string.format([[[LSP] yanked diagnostic message '%s']], msg),
      vim.log.levels.INFO
    )
    return
  end

  vim.ui.select(
    vim.tbl_map(function(d)
      return d.message
    end, diags),
    { prompt = 'Select diagnostic message to yank: ' },
    _yank
  )
end, { desc = 'Yank diagnostic message on current line' })
