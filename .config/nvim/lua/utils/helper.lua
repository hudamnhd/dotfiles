local M = {}

M.__HAS_NVIM_011 = vim.fn.has("nvim-0.11") == 1

local diff_enabled = false

function M.toggle_diff_buff()
  if diff_enabled then
    vim.cmd("windo diffoff")
  else
    vim.cmd("windo diffthis")
  end
  diff_enabled = not diff_enabled
end

---- NOTE utils
local fast_event_aware_notify = function(msg, level, opts)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level, opts)
    end)
  else
    vim.notify(msg, level, opts)
  end
end

function M.info(msg)
  fast_event_aware_notify(msg, vim.log.levels.INFO, {})
end

function M.warn(msg)
  fast_event_aware_notify(msg, vim.log.levels.WARN, {})
end

function M.err(msg)
  fast_event_aware_notify(msg, vim.log.levels.ERROR, {})
end

function M.shell_error()
  return vim.v.shell_error ~= 0
end

function M.git_root(cwd, noerr)
  local cmd = { "git", "rev-parse", "--show-toplevel" }
  if cwd then
    table.insert(cmd, 2, "-C")
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if M.shell_error() then
    if not noerr then
      M.info(unpack(output))
    end
    return nil
  end
  return output[1]
end

function M.set_cwd(pwd)
  if not pwd then
    local parent = vim.fn.expand("%:h")
    pwd = M.git_root(parent, true) or parent
  end
  if vim.loop.fs_stat(pwd) then
    vim.cmd("cd " .. pwd)
    M.info(("pwd set to %s"):format(vim.fn.shellescape(pwd)))
  else
    M.warn(("Unable to set pwd to %s, directory is not accessible"):format(vim.fn.shellescape(pwd)))
  end
end

-- 'q': find the quickfix window
-- 'l': find all loclist windows
function M.find_qf(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == "l" and win["loclist"] == 1 then
      found = true
    end
    -- loclist window has 'quickfix' set, eliminate those
    if type == "q" and win["quickfix"] == 1 and win["loclist"] == 0 then
      found = true
    end
    if found then
      table.insert(win_tbl, { winid = win["winid"], bufnr = win["bufnr"] })
    end
  end
  return win_tbl
end

-- open quickfix if not empty
function M.open_qf()
  local qf_name = "quickfix"
  local qf_empty = function()
    return vim.tbl_isempty(vim.fn.getqflist())
  end
  if not qf_empty() then
    vim.cmd("copen")
    vim.cmd("wincmd J")
  else
    print(string.format("%s is empty.", qf_name))
  end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
function M.open_loclist_all()
  local wininfo = vim.fn.getwininfo()
  local qf_name = "loclist"
  local qf_empty = function(winnr)
    return vim.tbl_isempty(vim.fn.getloclist(winnr))
  end
  for _, win in pairs(wininfo) do
    if win["quickfix"] == 0 then
      if not qf_empty(win["winnr"]) then
        -- switch active window before ':lopen'
        vim.api.nvim_set_current_win(win["winid"])
        vim.cmd("lopen")
      else
        print(string.format("%s is empty.", qf_name))
      end
    end
  end
end

-- toggle quickfix/loclist on/off
-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
function M.toggle_qf(type)
  local windows = M.find_qf(type)
  if #windows > 0 then
    -- hide all visible windows
    for _, win in ipairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    -- no windows are visible, attempt to open
    if type == "l" then
      M.open_loclist_all()
    else
      M.open_qf()
    end
  end
end

function M.lsp_get_clients(opts)
  ---@diagnostic disable-next-line: deprecated
  if M.__HAS_NVIM_011 then
    return vim.lsp.get_clients(opts)
  end
  ---@diagnostic disable-next-line: deprecated
  local clients = opts.bufnr and vim.lsp.buf_get_clients(opts.bufnr)
      or opts.id and { vim.lsp.get_client_by_id(opts.id) }
      or vim.lsp.get_clients(opts)
  return vim.tbl_map(function(client)
    return setmetatable({
      supports_method = function(_, ...) return client.supports_method(...) end,
      request = function(_, ...) return client.request(...) end,
      request_sync = function(_, ...) return client.request_sync(...) end,
    }, { __index = client })
  end, clients)
end

return M
