local FILES = {} -- current list
local LAST_FILES -- last known list written to file
local SYNC = false -- needs to read the list from file if false
local AUGROUP = vim.api.nvim_create_augroup('mru', {})

local MAX_FILES = 100
local MRU_PATH = vim.fn.stdpath('cache') .. '/mru'
local TMP_PATH = MRU_PATH .. '.' .. tostring(assert(vim.loop.getpid()))

local success = vim.fn.isdirectory(vim.fn.stdpath('cache')) == 1

if not success then vim.fn.mkdir(vim.fn.stdpath('cache'), 'p') end

--------------------------------------------------------------------------------
-- Most recently used files
-- taken from: https://github.com/ii14/dotfiles/blob/master/.config/nvim/lua/mru.lua
-- TODO: don't run with --headless
-- TODO: cache real paths for buffers?

---Filter table in place
---@generic T
---@param t T[]
---@param f fun(T): boolean
---@return T[]
local function filter(t, f)
  local len = #t
  local j = 1
  for i = 1, len do
    t[j], t[i] = t[i], nil
    if f(t[j]) then j = j + 1 end
  end
  for i = j, len do
    t[i] = nil
  end
  return t
end

local function sync()
  if SYNC then return end
  SYNC = true

  local file = io.open(MRU_PATH, 'rb')
  if not file then return end
  FILES = vim.split(file:read('*a'), '\n', { plain = true, trimempty = true })
  LAST_FILES = vim.deepcopy(FILES)
  file:close()
end

vim.api.nvim_create_autocmd({ 'FocusLost', 'VimSuspend', 'VimLeavePre' }, {
  group = AUGROUP,
  desc = 'mru: write',
  callback = function()
    -- don't write if desynced or nothing changed
    if not SYNC or vim.deep_equal(FILES, LAST_FILES) then return end

    -- we're leaving vim now and the file could be changed when we get back
    SYNC = false

    local file = io.open(TMP_PATH, 'w+b')
    if not file then return end
    file:write(table.concat(FILES, '\n'))
    file:flush()
    file:close()
    vim.loop.fs_rename(TMP_PATH, MRU_PATH)
    LAST_FILES = FILES
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
  group = AUGROUP,
  desc = 'mru: add file',
  callback = function(ctx)
    -- only normal buffers
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

    sync()

    -- remove duplicates
    filter(FILES, function(v) return v ~= file end)

    table.insert(FILES, 1, file)

    -- trim the list to MAX_FILES
    for i = MAX_FILES + 1, #FILES do
      FILES[i] = nil
    end
  end,
})

local function get()
  sync()
  -- clean up deleted files here
  filter(FILES, function(v) return not not vim.loop.fs_stat(v) end)

  local current_file = vim.fn.expand('%:p')

  local COPY = vim.deepcopy(FILES)
  if COPY[1] == current_file then table.remove(COPY, 1) end

  return COPY
end

local function get_filtered(opts)
  local home = vim.fn.expand('~')
  local cwd = vim.loop.cwd()
  opts = opts or {}
  local current = vim.fn.expand('%:p')
  local list = get()
  local filtered = vim.tbl_filter(function(path) return path ~= current end, list)
  if opts.scope == 'cwd' then
    local _cwd = vim.loop.cwd() .. '/'
    filtered = vim.tbl_filter(function(path) return path:sub(1, #_cwd) == _cwd end, filtered)
  end

  for i, path in ipairs(filtered) do
    if path:sub(1, #cwd + 1) == cwd .. '/' then
      filtered[i] = path:sub(#cwd + 2)
    elseif path:sub(1, #home + 1) == home .. '/' then
      filtered[i] = '~/' .. path:sub(#home + 2)
    end
  end

  return filtered
end

_G.MRU = {
  get = get_filtered,
}

--------------------------------------------------------------------------------
