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


local fzf_lua = require("fzf-lua")
 function M.asynctasks()
  local rows = vim.fn["asynctasks#source"](vim.go.columns * 48 / 100)
  fzf_lua.fzf_exec(function(cb)
    for _, e in ipairs(rows) do
      local color = fzf_lua.utils.ansi_codes
      local line = color.green(e[1]) .. " " .. color.cyan(e[2]) .. ": " .. color.yellow(e[3])
      cb(line)
    end
    cb()
  end, {
    actions = {
      ["default"] = function(selected)
        print(vim.inspect(selected))
        local str = fzf_lua.utils.strsplit(selected[1], " ")
        local command = "AsyncTask " .. vim.fn.fnameescape(str[1])
        vim.defer_fn(function()
          vim.api.nvim_exec(command, false)
        end, 500) -- 5000 milliseconds = 5 seconds
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--nth"] = "1",
    },
    winopts = {
      height = 0.6,
      width = 0.6,
    },
  })
end


local function echo(chunks)
  vim.api.nvim_echo(chunks, false, {})
end


function M.bookmarks()

-- stylua: ignore start
  local bookmarks = {
    {'1', 'files +100k',              [[lua require('fzf-lua').fzf_exec("fdfind --size +100k", { actions = require'fzf-lua'.defaults.actions.files })]]} ,

    {'w', 'files search cword',       [[lua require('fzf-lua').files({ fzf_opts = { ["--query"] = vim.fn.expand("<cword>") } }) ]]},
    {'W', 'files search visual',      [[lua require('fzf-lua').files({ fzf_opts = { ["--query"] = require("utils.other").get_visual_selection(true) } }) ]]},

    {'o', 'colorschemes',             [[FzfLua colorschemes          ]]} ,
    {'O', 'highlights',               [[FzfLua highlights            ]]} ,

    {'p', '%:h'},

    {'a', 'asyncrun_open',            [[call luaeval('require"utils.menus".asynctasks()')]]},

    {'s', 'SignatureListBufferMarks', [[SignatureListBufferMarks        ]]} ,

    {'d', 'diagnostics_workspace',    [[FzfLua diagnostics_workspace ]]} ,
    {'D', 'diagnostics_document',     [[FzfLua diagnostics_document  ]]} ,

    {'f', 'builtin',                  [[FzfLua builtin               ]]} ,
    {'F', 'filetypes',                [[FzfLua filetypes             ]]} ,

    {'g', 'grep',                     [[FzfLua grep                  ]]} ,
    {'G', 'grep',                     [[FzfLua grep resume=true      ]]} ,

    {'h', 'search_history',           [[FzfLua search_history        ]]} ,
    {'H', 'help_tags',                [[FzfLua help_tags             ]]} ,

    {'j', 'changes',                  [[FzfLua changes               ]]} ,
    {'J', 'jumps',                    [[FzfLua jumps                 ]]} ,

    {'K', 'keymaps',                  [[FzfLua keymaps               ]]} ,

    {'m', 'marks',                    [[FzfLua marks                 ]]} ,
    {'M', 'man_pages',                [[FzfLua man_pages             ]]} ,

    {'c', 'command_history',          [[FzfLua command_history       ]]} ,
    {'C', 'commands',                 [[FzfLua commands              ]]} ,

    {'z', 'lazy',                     [[Lazy                         ]]} ,
    {'b', 'buffers',                  [[FzfLua buffers               ]]} ,
    {'n', '~/vimwiki'},
  }
-- stylua: ignore end

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

-- stylua: ignore start
  {'-', 'set_cwd',               [[lua require"utils.other".set_cwd()]]},

  {'p', 'MarkdownPreviewToggle', [[MarkdownPreviewToggle]]},

  {'b', 'diffoff',               [[windo diffoff]]},
  {'B', 'diffthis',              [[windo diffthis]]},

  {'s', 'LiveServerStop',        [[LiveServerStop]]},
  {'S', 'LiveServerStart',       [[LiveServerStart]]},

  {'w', 'wrap',                  [[setl wrap! | setl wrap?]]},
  {'W', 'wrapscan',              [[set wrapscan! | set wrapscan?]]},

  {'n', 'line numbers',          [[call luaeval('require"utils.menus".toggle_line_numbers()')]]},
  {'h', 'MiniHipatterns',        [[lua MiniHipatterns.toggle()]]},
  {'l', 'list',                  [[setl list! | setl list?]]},
  {'d', 'diagnostics',           function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end},
  {'c', 'ignorecase',            [[set ignorecase! | set ignorecase?]]},
  {'z', 'spell',                 [[setl spell! | setl spell?]]},
  -- {'f', 'folds',                 [[setl foldenable! | setl foldenable?]]},
  -- {'m', 'mouse',                 [[let &mouse = (&mouse ==# '' ? 'nvi' : '') | set mouse?]]},
}
-- stylua: ignore end

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

local function diffthis_with_diffoff()
  -- Check if diff mode is active
  if vim.wo.diff then
    -- Turn off diff mode
    vim.cmd('diffoff')
    vim.cmd('Gitsigns diffthis')
  end
  -- Run Gitsigns diffthis
  vim.cmd('Gitsigns diffthis')
end

-- Create a command to call the function
vim.api.nvim_create_user_command('DiffThisWithDiffOff', diffthis_with_diffoff, {})


-- stylua: ignore start
local gitsigns = {
  {'j', '󰊢  diffget //2',               [[diffget //2]]},
  {'k', '󰊢  diffget //3',               [[diffget //3]]},

  {'a', '󰊢  Agit',                      [[Agit]]},
  {'s', '󰊢  AgitFile',                  [[AgitFile]]},

  {'S', '󰊢  git_status',                [[FzfLua git_status]]},
  {'d', '󰊢  DiffThisWithDiffOff',       [[DiffThisWithDiffOff]]},
  {'c', '󰊢  git_bcommits',              [[FzfLua git_bcommits]]},
  {'C', '󰊢  git_commits',               [[FzfLua git_commits]]},
  {'b', '󰊢  blame_line',                [[lua require("gitsigns").blame_line({full=true})]]},
  {'B', '󰊢  git_branches',              [[FzfLua git_branches]]},
  {'p', '󰊢  preview_hunk',              [[lua require("gitsigns").preview_hunk()]]},
  {'x', '󰊢  toggle_deleted',            [[lua require("gitsigns").toggle_deleted()]]},
  {'X', '󰊢  reset_buffer',              [[lua require("gitsigns").reset_buffer()]]},
}
-- stylua: ignore end

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


local resession = require("resession")

local genghist = {
  {'1', "  Copy path",                   "CopyFilepath"},
  {'2', "  Copy relative path",          "CopyRelativePath"},
  {'3', "  Copy filename",               "CopyFilename"},
  {'r', "  Rename file",                 "RenameFile"},
  {'m', "  Move file",                   "MoveFile"},
  {'M', "  Move file and rename",        "MoveAndRenameFile"},
  {'X', "  chmod +x",                    "Chmodx"},
  {'y', "  Duplicate file",              "DuplicateFile"},
  {'d', "  Move file to trash",          "TrashFile"},
  {'n', "  Create new file",             "CreateNewFile"},
  {'c', "  Selection to new file",       "MoveSelectionToNewFile"},
  {' ',  "===============================", ""},
  {"w", "[S]ession [S]ave",               resession.save, },
  {"t", "[S]ession save [T]ab",           function() resession.save_tab() end, },
  {"o", "[S]ession [O]pen",               resession.load, },
  {"l", "[S]ession [L]oad without reset", function() resession.load(nil, { reset = false }) end, },
  {"x", "[S]ession [D]elete",             resession.delete, },
}

function M.genghist()
  local items = genghist
  for _, item in ipairs(items) do
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2]},
    }
  end
  echo {{'File & Sessions'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    return
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(items) do
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

-- local function generate_control_chars()
--   local control_chars = {}
--   for i = 1, 26 do
--     local char = string.char(i)
--     control_chars[char] = '<C-' .. string.char(i + 64) .. '>'
--   end
--   return control_chars
-- end
--
-- local control_chars = generate_control_chars()
--
--
-- local function pad_string(str, length)
--   if not length then
--     return str
--   end
--   local pad_left = math.floor((length - #str) / 2)
--   local pad_right = length - #str - pad_left
--   return string.rep(' ', pad_left) .. str .. string.rep(' ', pad_right)
-- end
