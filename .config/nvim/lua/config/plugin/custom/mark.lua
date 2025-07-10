local M = {}
--------------------------------------------------------------------------------
-- MARK

-- Marks visibility toggle
local enabled = true

--- Path to file where marks are stored as JSON
local STORAGE_PATH = vim.fn.stdpath('data') .. '/nvim-marks.json'

--- Internal storage of marks, grouped by project/git branch
---@type table<string, table<string, { file: string, pos: { [1]: integer, [2]: integer } }>>
local maps = {}

-- Create a namespace for virtual highlights (extmarks)
local ns = vim.api.nvim_create_namespace('marks')

-- Use the 'NonText' highlight group for background color
local nontext_color = vim.api.nvim_get_hl(0, { name = 'NonText' })
vim.api.nvim_set_hl(0, 'Mark', { bg = nontext_color.fg })

-- Configuration for rendering marks
local config = {
  pos_hl = '', -- Highlight at mark position
  sign_hl = 'SignatureMarkLine', -- Sign column highlight
  line_hl = 'Cursorline', -- Line highlight (optional)
  num_hl = 'SignatureMarkLine', -- Line number highlight (optional)
  priority = nil, -- Extmark priority
  filter = function(mark) return mark:match('[a-zA-Z]') end,
  format = function(mark)
    return mark:gsub("'", '') -- Remove leading `'`
  end,
}

--- Set an extmark with highlight and optional sign
---@param bufnr integer
---@param mark string
---@param line integer (0-indexed)
---@param col integer (0-indexed)
local function set_mark_extmark(bufnr, mark, line, col)
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, col, {
    hl_group = config.pos_hl,
    sign_hl_group = config.sign_hl,
    line_hl_group = config.line_hl,
    number_hl_group = config.num_hl,
    end_col = col + 1,
    priority = config.priority,
    sign_text = config.format and config.format(mark) or mark,
  })
end

--- Returns unique project ID based on git root + branch or cwd fallback
---@return string
local function get_map_id()
  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD')
  if vim.v.shell_error == 0 then
    local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('%s+$', '')
    return git_root .. ':' .. branch:gsub('%s+$', '')
  end
  return vim.fn.getcwd()
end

--- Save current marks into JSON file
local function save_maps()
  local file = io.open(STORAGE_PATH, 'w')
  if not file then return end
  local json = vim.fn.json_encode(maps)
  file:write(json)
  file:close()
end

--- Load marks from JSON file and refresh current buffer highlights
local function load_maps()
  local file = io.open(STORAGE_PATH, 'r')
  if not file then return end

  local content = file:read('*all')
  file:close()

  local ok, decoded = pcall(vim.fn.json_decode, content)
  if ok then maps = decoded end
end

--- Clear extmarks for a buffer
---@param bufnr integer
function M.clear_ns(bufnr) vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1) end

--- Draw all valid local marks in a buffer
---@param bufnr integer
local function draw_local_marks(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local map_id = get_map_id()
  local project_marks = maps[map_id] or {}

  for char, data in pairs(project_marks) do
    if data.file == bufname and config.filter(char) then
      local line = data.pos[1] - 1 -- extmark pakai 0-based
      local col = data.pos[2]
      set_mark_extmark(bufnr, char, line, col)
    end
  end
end

--- Redraw all marks in a buffer
---@param bufnr? integer
function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  M.clear_ns(bufnr)
  draw_local_marks(bufnr)
  save_maps()
end

local function toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  if enabled then
    enabled = false
    M.clear_ns(bufnr)
  else
    enabled = true
    M.refresh(bufnr)
  end
end

-- Auto-refresh marks on buffer events
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function(args)
    if enabled then M.refresh(args.buf) end
  end,
  desc = 'Refresh buffer marks',
})

load_maps()

--- Handle deletion of marks (triggered via :delmarks)
---@param args string
local function handle_delmarks(args)
  local map_id = get_map_id()
  if not maps[map_id] then return end

  if args == '!' then
    maps[map_id] = {}
  elseif args:match('^[a-z]$') then
    maps[map_id][args] = nil
  elseif args:match('^[a-z]%-[a-z]$') then
    local start_char, end_char = args:match('([a-z])-([a-z])')
    for char = string.byte(start_char), string.byte(end_char) do
      maps[map_id][string.char(char)] = nil
    end
  else
    for char in args:gmatch('[a-z]') do
      maps[map_id][char] = nil
    end
  end

  save_maps()
end

local function get_next_free_mark(map_id)
  local letters = 'abcdefghijklmnopqrstuvwxyz'
  maps[map_id] = maps[map_id] or {}

  for i = 1, #letters do
    local mark = letters:sub(i, i)
    if not maps[map_id][mark] then return mark end
  end

  return nil -- Semua terpakai
end

function M.setup()
  -- User command: :MarksToggle
  vim.api.nvim_create_user_command('MarksToggle', toggle, {})

  local function clear_all_marks()
    local map_id = vim.fn.getcwd()

    if maps[map_id] then
      maps[map_id] = nil
      print('🧹 Semua mark dihapus.')
    else
      print('ℹ️ Tidak ada mark untuk dihapus.')
    end
  end
  -- delete all mark: :MarksClear
  vim.api.nvim_create_user_command('MarksClear', clear_all_marks, {})

  -- unset mark with dm + mark
  vim.keymap.set('n', 'dm', function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local mark = vim.fn.getcharstr()

    if config.filter(mark) ~= nil then
      local bufname = vim.fn.expand('%:p')

      local map_id = get_map_id()
      maps[map_id] = maps[map_id] or {}
      local existing = maps[map_id][mark]

      if existing and existing.file == bufname and existing.pos[1] == line then
        maps[map_id][mark] = nil
        vim.api.nvim_buf_del_mark(0, mark) -- native mark remove
        vim.api.nvim_echo({
          { ('Mark %s removed'):format(mark), 'DiffDelete' },
        }, false, {})
      end

      if enabled then M.refresh() end
    end
  end, { desc = 'Unset mark and highlight' })

  vim.keymap.set('n', '<Leader>`', function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    local current_line_content = vim.fn.getline(line)
    if current_line_content == '' then
      vim.api.nvim_echo({
        { 'Cannot mark empty lines.', 'WarningMsg' },
      }, false, {})
      return
    end

    local map_id = get_map_id()
    local mark = get_next_free_mark(map_id)
    if not mark then return end
    if config.filter(mark) ~= nil then
      local bufname = vim.fn.expand('%:p')

      -- Check if there is already a mark in this file and line
      for key, mark_data in pairs(maps[map_id]) do
        if mark_data.file == bufname and mark_data.pos[1] == line then
          -- Hapus mark
          maps[map_id][key] = nil
          vim.api.nvim_buf_del_mark(0, key)
          vim.api.nvim_echo({
            { ('❌ Mark %s removed'):format(key), 'DiagnosticError' },
          }, false, {})
          if enabled then M.refresh() end
          return
        end
      end

      maps[map_id] = maps[map_id] or {}

      maps[map_id][mark] = {
        file = bufname,
        pos = { line, col },
      }
      vim.api.nvim_buf_set_mark(0, mark, line, col, {})
      vim.api.nvim_echo({
        { ('Mark %s set'):format(mark), 'DiagnosticOk' },
      }, false, {})

      if enabled then M.refresh() end
    end
  end, { desc = 'Set mark and highlight' })

  vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = vim.api.nvim_create_augroup('NvimMarksDelmarks', { clear = true }),
    callback = function()
      local cmdline = vim.fn.getcmdline()
      local args = cmdline:match('^delmarks%s+(.+)$')
      if args and args:match('[a-z!]') then vim.schedule(function() handle_delmarks(args) end) end
    end,
  })

  --------------------------------------------------------------------------------
  -- SHOW PICKER MARK
  function M.marks()
    local map_id = get_map_id()
    local marks = maps[map_id] or {}
    if vim.tbl_isempty(marks) then
      vim.notify('No marks in this project')
      return
    end

    local display_marks = {}

    for key, mark_data in pairs(marks) do
      local path = vim.fn.fnamemodify(mark_data.file, ':~:.')
      local line = tonumber(mark_data.pos[1])
      local col = tonumber(mark_data.pos[2])

      local cmd = function()
        local stat = vim.loop.fs_stat(path)
        if stat then
          vim.cmd('edit +' .. line .. ' ' .. path)
          vim.api.nvim_win_set_cursor(0, { line, col })
        else
          maps[map_id][key] = nil
          vim.api.nvim_echo({ { ('File not found and mark %s removed'):format(key), 'DiffDelete' } }, false, {})
          if enabled then M.refresh() end
        end
      end

      table.insert(display_marks, { mode = 'n', key = key, label = path .. ':' .. line .. ':' .. col, cmd = cmd })
    end

    require('config.util').echo_picker({ title = 'Marks', items = display_marks })

  end

  vim.keymap.set('n', "<Leader><Tab>", "<Cmd>lua require('config.plugin.custom.mark').marks()<CR>", {
    desc = 'Show Marks',
  })

end

M.setup()

return M

--------------------------------------------------------------------------------
