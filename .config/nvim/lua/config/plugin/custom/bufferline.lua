local blines = {} -- local state buffers
local ns = vim.api.nvim_create_namespace('mark-buff')

local function relpath(path)
  local cwd = vim.loop.cwd()
  ---@diagnostic disable-next-line: need-check-nil
  local safe_cwd = cwd:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
  return (path:gsub('^' .. safe_cwd .. '/', ''))
end

-- sinkron blines
vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
  callback = function(args)
    local bufnr = args.buf
    -- filter blines, hapus jika idbuf sudah tidak valid
    local new_blines = {}
    for _, entry in ipairs(blines) do
      if entry.idbuf ~= bufnr then table.insert(new_blines, entry) end
    end
    blines = new_blines
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function()
    local known = {}
    for _, entry in ipairs(blines) do
      known[entry.path] = true
    end

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buflisted then
        local name = vim.api.nvim_buf_get_name(bufnr)
        local path = relpath(name)
        if path ~= '' and not known[path] then table.insert(blines, { idbuf = bufnr, path = path }) end
      end
    end
  end,
})

local function buff()
  if #blines == 0 then
    vim.notify('mark is empty.', vim.log.levels.WARN)
    return
  end

  local current_path = relpath(vim.api.nvim_buf_get_name(0))
  -- Buat floating buffer
  local buf_id = vim.api.nvim_create_buf(false, true)
  local columns, lines = vim.o.columns, vim.o.lines
  local width, height = math.floor(columns * 0.9), math.floor(lines * 0.6)
  local win_opts = {
    relative = 'editor',
    style = 'minimal',
    row = math.floor((lines - height) * 0.5),
    col = math.floor((columns - width) * 0.5),
    width = width,
    height = height,
    border = 'single',
    title = 'Buffer List',
    title_pos = 'center',
  }
  local win_id = vim.api.nvim_open_win(buf_id, true, win_opts)

  vim.wo[win_id].number = true
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf_id })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf_id })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf_id })
  vim.api.nvim_buf_set_name(buf_id, 'buffer')
  vim.api.nvim_set_current_buf(buf_id)

  local lines = {}
  for _, entry in ipairs(blines) do
    table.insert(lines, entry.path)
  end
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  local target_line = 1
  for idx, entry in ipairs(blines) do
    if entry.path == current_path then
      target_line = idx
      break
    end
  end

  -- Set cursor ke line tersebut
  vim.api.nvim_win_set_cursor(win_id, { target_line, 0 })
  -- Set lines dan highlight
  for i, line in ipairs(lines) do
    local fname_start = line:find('[^/]+$') or 1
    local fname_end = #line
    if fname_start > 1 then
      vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, 0, {
        end_col = fname_start - 1,
        hl_group = 'Comment',
      })
    end
    vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, fname_start - 1, {
      end_col = fname_end,
      hl_group = 'Title',
    })
  end

  -- Keymaps
  vim.keymap.set('n', 'q', vim.cmd.bw, { buffer = buf_id, nowait = true })
  local function buf_enter()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
    if not line or line == '' then return end

    -- Cari path di blines
    local target = nil
    for _, entry in ipairs(blines) do
      if entry.path == line then
        target = entry
        break
      end
    end

    if not target or not vim.api.nvim_buf_is_valid(target.idbuf) then
      vim.notify('Invalid buffer for path: ' .. line, vim.log.levels.WARN)
      return
    end

    vim.cmd.bw() -- tutup floating menu
    vim.schedule(function() vim.api.nvim_set_current_buf(target.idbuf) end)
  end
  vim.keymap.set('n', '<CR>', buf_enter, { buffer = buf_id, desc = 'Switch to buffer under cursor' })
  vim.keymap.set('n', 'l', buf_enter, { buffer = buf_id, desc = 'Switch to buffer under cursor' })

  vim.keymap.set('n', '<Leader>w', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local old_paths = {}
    for _, entry in ipairs(blines) do
      old_paths[entry.path] = entry.idbuf
    end

    local new_paths = {}
    local filtered = {}
    for _, file in ipairs(lines) do
      local bufnr = vim.fn.bufnr(file)
      local real = vim.loop.fs_realpath(file)
      local stat = real and vim.loop.fs_stat(real)
      if stat and stat.type == 'file' then
        if bufnr == -1 then
          vim.cmd('badd ' .. vim.fn.fnameescape(file))
          bufnr = vim.fn.bufnr(file)
        end
        table.insert(filtered, { idbuf = bufnr, path = file })
        new_paths[file] = true
      end
    end

    -- handle bufdelete otomatis
    for path, bufnr in pairs(old_paths) do
      if not new_paths[path] and vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end

    blines = filtered
    vim.notify('Updated buffer list.')
  end, { buffer = buf_id })
end

vim.keymap.set('n', '<Leader>j', buff, { desc = 'Show buffer' })

-- show bufferline via tabline
vim.o.showtabline = 2
vim.o.tabline = '%!v:lua.render_tabline()'

local seen = {}

function _G.render_tabline()
  local current = vim.fn.bufnr()
  local alternate = vim.fn.bufnr('#')
  local tab_count = vim.fn.tabpagenr('$')
  local tab_index = vim.fn.tabpagenr()

  local line = ''
  if tab_count > 1 then line = line .. '%#TabLineCount#' .. string.format('[Tab %d/%d] ', tab_index, tab_count) end

  -- pakai blines sebagai sumber urutan
  for i, buf in ipairs(blines) do
    local path = buf.path
    local bufnr = buf.idbuf
    if bufnr ~= -1 then
      local modified = vim.fn.getbufvar(bufnr, '&modified') == 1
      local is_current = (bufnr == current)
      local is_alt = (bufnr == alternate)

      local suffix = ''
      if modified then suffix = suffix .. '**' end
      if is_alt then suffix = suffix .. '#' end

      local hl = is_current and '%#TabLineSel#' or '%#TabLine#'
      local name = vim.fn.fnamemodify(path, ':t') or '[No Name]'
      local short_name = name
      seen[name] = (seen[name] or 0) + 1

      if seen[name] > 1 then
        local parent = vim.fn.fnamemodify(path, ':h:t')
        if parent == '' then parent = '...' end
        short_name = string.format('%s/%s', parent, name)
      end

      local label = string.format('%d %s%s', i, short_name, suffix)
      local click = string.format('%%%d@v:lua.minimal_switch_buffer@ ', bufnr)

      line = line .. hl .. click .. label .. ' ' .. '%X'
    end
  end

  return line .. '%#TabLineFill#'
end

-- click tabline
function _G.minimal_switch_buffer(bufnr) vim.api.nvim_set_current_buf(bufnr) end

-- use i for navigate bufferline (ex 2i)
-- vim.keymap.set('n', 'i', function()
--   local count = vim.v.count
--   if count == 0 then
--     config.feedkeys('i')
--     return
--   end
--   if count > 10 then return end
--
--   local target = blines[count]
--   if target then
--     vim.api.nvim_set_current_buf(target.idbuf)
--   else
--     vim.notify('Buffer #' .. count .. ' not found', vim.log.levels.WARN)
--   end
-- end, { desc = 'Jump to buffer by count (e.g. 2i)' })

-- -- use space + number(1-9) for navigate bufferline
local keys = '12345'
for i = 1, #keys do
  local key = keys:sub(i, i)
  local key_combination = string.format('<space>%s', key)
  vim.keymap.set('n', key_combination, function()
    local target = blines[i]
    if target then
    vim.api.nvim_set_current_buf(target.idbuf)
    else
      vim.notify('Buffer #' .. i .. ' not found', vim.log.levels.WARN)
    end
  end, { desc = 'Goto buffer ' .. i })
end
