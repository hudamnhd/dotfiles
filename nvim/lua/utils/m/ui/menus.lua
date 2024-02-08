local M = {}
local api = vim.api
local m = require("utils.m")

do
  local LINE_NUMBERS = {
    ff = '  number   relativenumber',
    ft = '  number norelativenumber',
    tf = 'nonumber norelativenumber',
    tt = '  number norelativenumber',
  }
  ---Toggle line numbers
  function M.toggle_line_numbers()
    local n = vim.o.number         and 't' or 'f'
    local r = vim.o.relativenumber and 't' or 'f'
    local cmd = LINE_NUMBERS[n..r]
    api.nvim_command('set '..cmd)
    m.echo(cmd, nil, false)
  end
end


local function echo(chunks)
  vim.api.nvim_echo(chunks, false, {})
end

function M.bookmarks()
local bookmarks = {
  {'m', 'marks',                 [[FzfLua marks                 ]]},
  {'g', 'git_files',             [[FzfLua git_files             ]]},
  {'f', 'builtin',               [[FzfLua builtin               ]]},
  {'b', 'lgrep_curbuf',          [[FzfLua lgrep_curbuf          ]]},
  {'j', 'jumps',                 [[FzfLua jumps                 ]]},
  {'n', '~/vimwiki'},
  {'x', 'command_history',       [[FzfLua command_history       ]]},
  {'e', 'diagnostics_document',  [[FzfLua diagnostics_document  ]]},
  {'d', 'diagnostics_workspace', [[FzfLua diagnostics_workspace ]]},
  {'l', 'lazy',                  [[Lazy                         ]]},
  {'o', 'colorschemes',          [[FzfLua colorschemes          ]]},
  {'c', 'change dir',            [[Directories                  ]]},
  {'O', 'highlights',            [[FzfLua highlights            ]]},
  {'/', 'search_history',        [[FzfLua search_history        ]]},
  {'?', 'keymaps',               [[FzfLua keymaps               ]]},
  {':', 'commands',              [[FzfLua commands              ]]},
  {'t', 'help_tags',             [[FzfLua help_tags             ]]},
  {'M', 'man_pages',             [[FzfLua man_pages             ]]},
}
  if type(bookmarks) ~= 'table' then
    echo {{'Invalid g:bookmarks', 'ErrorMsg'}}
    return
  end

  for _, item in ipairs(bookmarks) do
    local hl
    if item[3] then
      hl = 'Function'
    end
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2], hl},
    }
  end
  echo {{':FzfLua files'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 --[[<Esc>]] then
    return
  elseif ch == 13 --[[<CR>]] then
    vim.cmd('FzfLua files')
  elseif ch == 32 --[[<Space>]] then
    vim.api.nvim_feedkeys(':FzfLua files ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(bookmarks) do
      local s1, s2 = item[1], nil
      -- make lowercase characters work with ctrl
      if s1:match('^%l$') then
        s2 = T('<C-'..s1..'>')
      end
      if s1 == ch or (s2 and s2 == ch) then
        vim.cmd(item[3] or ('FzfLua files cwd='..item[2]))
        return
      end
    end
  end
end






local options = {
  {'-', 'set_cwd',         [[lua require"utils".set_cwd()]]},
  {'y', 'copy_file',       [[!cp '%:p' '%:p:h/%:t:r-copy.%:e']]},
  {'B', 'diffthis',        [[windo diffthis]]},
  {'b', 'diffoff',         [[windo diffoff]]},
  {'S', 'LiveServerStart', [[LiveServerStart]]},
  {'s', 'LiveServerStop',  [[LiveServerStop]]},
  {'w', 'wrap',            [[setl wrap! | setl wrap?]]},
  {'C', 'ignorecase',      [[set ignorecase! | set ignorecase?]]},
  {'l', 'list',            [[setl list! | setl list?]]},
  {'n', 'line numbers',    [[call luaeval('require"m.ui.menus".toggle_line_numbers()')]]},
  {'i', 'indent',          [[lua require'configs.mini'.btoggle()]]},
  {'c', 'colorizer',       [[ColorizerToggle]]},
  {'d', 'diagnostics',     function()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
  end},
  {'W', 'wrapscan',        [[set wrapscan! | set wrapscan?]]},
  {'z', 'spell',           [[setl spell! | setl spell?]]},
  {'f', 'folds',           [[setl foldenable! | setl foldenable?]]},
  {'m', 'mouse',           [[let &mouse = (&mouse ==# '' ? 'nvi' : '') | set mouse?]]},
}

function M.options()
  for _, item in ipairs(options) do
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2]},
    }
  end
  echo {{':set'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    vim.api.nvim_feedkeys(':set ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(options) do
      if item[1] == ch then
        local cmd = item[3]
        if type(cmd) == 'function' then
          cmd()
        else
          vim.cmd(cmd)
        end
        return
      end
    end
  end
end


local gitsigns = {
  {'g', 'git_full',                  [[0G]]},
  {'v', 'Git diffsplit',             [[Gvdiffsplit!]]},
  {'1', 'git_status',                [[FzfLua git_status]]},
  {'2', 'git_commits',               [[FzfLua git_commits]]},
  {'3', 'git_bcommits',              [[FzfLua git_bcommits]]},
  {'4', 'git_branches',              [[FzfLua git_branches]]},
  {'d', 'diffthis',                  [[lua require("gitsigns").diffthis()]]},
  {'e', 'diffthis prev commit',      [[lua require("gitsigns").diffthis("~1")]]},
  {'p', 'preview_hunk',              [[lua require("gitsigns").preview_hunk()]]},
  {'l', 'preview_hunk_inline',       [[lua require("gitsigns").preview_hunk_inline()]]},
  {'X', 'reset_buffer',              [[lua require("gitsigns").reset_buffer()]]},
  {'t', 'toggle_current_line_blame', [[lua require("gitsigns").toggle_current_line_blame()]]},
  {'b', 'blame_line',                [[lua require("gitsigns").blame_line({full=true})]]},
  {'x', 'toggle_deleted',            [[lua require("gitsigns").toggle_deleted()]]},
  {'a', 'stage_buffer',              [[lua require("gitsigns").stage_buffer()]]},
  {'u', 'undo_stage_hunk',           [[lua require("gitsigns").undo_stage_hunk()]]},
}

function M.gitsigns()
  for _, item in ipairs(gitsigns) do
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2]},
    }
  end
  echo {{'Git'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    return
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(gitsigns) do
      if item[1] == ch then
        local cmd = item[3]
        if type(cmd) == 'function' then
          cmd()
        else
          vim.cmd(cmd)
        end
        return
      end
    end
  end
end


return M
