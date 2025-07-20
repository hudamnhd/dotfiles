local MAX_FILES = 100
local mark = {}
local json_path = vim.fn.stdpath('state') .. '/bookmarks.json'
-------------------------------------------------------------------------------
-- BOOKMARK FILES

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

-- Helpers
local function split_filename_line(input)
  local filename, line = input:match('^(.-):(%d+)$')
  if filename and line then
    return filename, tonumber(line)
  else
    return input, 1
  end
end

local function load_json()
  local f = io.open(json_path, 'r')
  if not f then return {} end
  local ok, data = pcall(vim.fn.json_decode, f:read('*a'))
  f:close()
  return ok and data or {}
end

local function save_json(data)
  local f = io.open(json_path, 'w')
  if not f then
    vim.notify('Failed to write marks.json', vim.log.levels.ERROR)
    return
  end
  f:write(vim.fn.json_encode(data))
  f:close()
end

-- Tambah mark untuk file aktif
function mark.add()
  local file = vim.api.nvim_buf_get_name(0)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if file == '' then return end

  file = vim.loop.fs_realpath(file)
  if not file then return end

  local stat = vim.loop.fs_stat(file)
  if not stat or stat.type ~= 'file' then return end

  local map_id = get_map_id()
  local data = load_json()

  data[map_id] = data[map_id] or {}
  local files = data[map_id]

  -- hapus duplikat
  for i = #files, 1, -1 do
    local path, line = split_filename_line(files[i])
    if path == file then table.remove(files, i) end
  end

  table.insert(files, file .. ':' .. line)

  for i = #files, MAX_FILES + 1, -1 do
    table.remove(files, i)
  end

  save_json(data)

  vim.api.nvim_echo({
    { ('Mark add `%s`.'):format(file), 'DiagnosticHint' },
  }, true, {})
end

-- Hapus mark dari file aktif
function mark.del()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then return end

  file = vim.loop.fs_realpath(file)
  if not file then return end

  local map_id = get_map_id()
  local data = load_json()

  local files = data[map_id] or {}
  for i = #files, 1, -1 do
    local path, line = split_filename_line(files[i])
    if path == file then table.remove(files, i) end
  end

  data[map_id] = files
  save_json(data)

  vim.api.nvim_echo({
    { ('Mark remove `%s`.'):format(file), 'WarningMsg' },
  }, true, {})
end

-- Ambil daftar mark untuk cwd
function mark.get()
  local map_id = get_map_id()
  local data = load_json()
  return data[map_id] or {}
end

-- Buka file berdasarkan indeks
function mark.open(index)
  local files = mark.get()
  local file = files[index]
  if not file then
    vim.notify('No mark at index ' .. index, vim.log.levels.WARN)
    return
  end
  local path, line = split_filename_line(file)
  vim.cmd('e +' .. line .. ' ' .. vim.fn.fnameescape(path))
end

local real = nil

local ns = vim.api.nvim_create_namespace('highlight_filename')

function mark.edit()
  -- edite
  local map_id = get_map_id()
  local data = load_json()
  local marks = data[map_id] or {}
  if #marks == 0 then vim.notify('mark is empty.', vim.log.levels.WARN) end

  -- Buat buffer baru
  local win = config.win_open({ title = 'Bookmark' })

  vim.wo[win.win_id].number = true

  vim.api.nvim_buf_set_name(win.buf_id, map_id)
  vim.api.nvim_set_current_buf(win.buf_id)
  -- vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, marks)
  local cwd = vim.loop.cwd()
  local function relpath(path)
    -- pastikan trailing / supaya aman
    local safe_cwd = cwd:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    local str = path:gsub('^' .. safe_cwd .. '/', '')
    return str
  end

  local lines = {}
  for _, path in ipairs(marks) do
    table.insert(lines, relpath(path))
  end
  vim.api.nvim_buf_set_lines(win.buf_id, 0, -1, false, lines)

  for i, line in ipairs(lines) do
    local fname_start = line:find('[^/]+$')
    local fname_end = line:find(':') and line:find(':') - 1 or #line

    if fname_start then
      if fname_start > 1 then
        vim.api.nvim_buf_set_extmark(win.buf_id, ns, i - 1, 0, {
          end_col = fname_start - 1,
          hl_group = 'Comment',
        })
      end
      -- highlight filename
      vim.api.nvim_buf_set_extmark(win.buf_id, ns, i - 1, fname_start - 1, {
        end_col = fname_end,
        hl_group = 'Title',
      })
    end

    -- highlight linenr pakai DiagnosticWarn
    local linenr_start = line:find(':(%d+)')
    if linenr_start then
      local linenr_end = #line
      vim.api.nvim_buf_set_extmark(win.buf_id, ns, i - 1, linenr_start, {
        end_col = linenr_end,
        hl_group = 'DiagnosticWarn',
      })
    end
  end

  -- Keymap untuk menyimpan mark hasil edit
  vim.keymap.set('n', 'q', win.close_win, { buffer = win.buf_id, nowait = true })

  local function open_file()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local file = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
    if not file or file == '' then return end

    local path, line = split_filename_line(file)
    real = vim.loop.fs_realpath(path)
    if not real or not vim.loop.fs_stat(real) then
      vim.notify('Invalid path: ' .. line, vim.log.levels.WARN)
      return
    end

    win.close_win()
    vim.schedule(function() vim.cmd('e +' .. line .. ' ' .. vim.fn.fnameescape(real)) end)
  end

  vim.keymap.set('n', '<cr>', open_file, { buffer = true, desc = 'Open file under cursor' })
  vim.keymap.set('n', 'l', open_file, { buffer = true, desc = 'Open file under cursor' })

  vim.keymap.set('n', '<space>w', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local filtered = {}

    for _, file in ipairs(lines) do
      local path, line = split_filename_line(file)
      local real = vim.loop.fs_realpath(path)
      local stat = real and vim.loop.fs_stat(real)
      if stat and stat.type == 'file' then table.insert(filtered, real .. ':' .. line) end
    end

    if map_id then
      data[map_id] = filtered
      save_json(data)
      vim.notify('Marks updated.')
    else
      vim.notify('Error')
    end
  end, { buffer = true, desc = 'Save reordered marks' })
end

--------------------------------------------------------------------------------

-- Keymap
vim.keymap.set('n', '<Leader>ba', function() mark.add() end, { desc = 'Add bookmark' })
vim.keymap.set('n', '<Leader>be', function() mark.edit() end, { desc = 'Edit bookmark' })
vim.keymap.set('n', '<Leader>bd', function() mark.del() end, { desc = 'Del bookmark' })
vim.keymap.set('n', '<Leader>b1', function() mark.open(1) end, { desc = 'Go bookmark 1' })
vim.keymap.set('n', '<Leader>b2', function() mark.open(2) end, { desc = 'Go bookmark 2' })
vim.keymap.set('n', '<Leader>b3', function() mark.open(3) end, { desc = 'Go bookmark 3' })
vim.keymap.set('n', '<Leader>b4', function() mark.open(4) end, { desc = 'Go bookmark 4' })

-- Autocmd update cursor location when save
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = '*',
  callback = function(ctx)
    local buftype = vim.bo and vim.bo[ctx.buf].buftype or vim.vim.api.nvim_buf_get_option(ctx.buf, 'buftype')
    if buftype ~= '' then return end

    local file = ctx.file
    if not file or file == '' then return end

    file = vim.loop.fs_realpath(ctx.file)
    if not file then return end

    -- ignore commit messages
    local last = file:match('[^/]*$')
    if last and last == 'COMMIT_EDITMSG' then return end

    -- only files
    local stat = vim.loop.fs_stat(file)

    if not stat or stat.type ~= 'file' then return end

    local line = 1
    if vim.api.nvim_buf_is_loaded(ctx.buf) then
      local win = vim.fn.bufwinid(ctx.buf)
      if win ~= -1 then line = vim.api.nvim_win_get_cursor(win)[1] end
    end

    local map_id = get_map_id()
    local data = load_json()

    local files = data[map_id] or {}

    local should_update = false
    -- hapus duplikat
    for i = #files, 1, -1 do
      local path, line = split_filename_line(files[i])

      if path == file then
        table.remove(files, i)
        should_update = true
      end
    end

    if should_update then
      table.insert(files, file .. ':' .. line)

      for i = #files, MAX_FILES + 1, -1 do
        table.remove(files, i)
      end

      data[map_id] = files

      save_json(data)
    end
  end,
})
--------------------------------------------------------------------------------
