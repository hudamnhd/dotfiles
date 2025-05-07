local M = {}

_G.notify = _G.notify or {}
_G.win = _G.win or {}

local notify = function(msg, level, opts)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level, opts)
    end)
  else
    vim.notify(msg, level, opts)
  end
end

_G.notify.info = function(msg)
  notify(msg, vim.log.levels.INFO, {})
end

_G.notify.warn = function(msg)
  notify(msg, vim.log.levels.WARN, {})
end

_G.notify.err = function(msg)
  notify(msg, vim.log.levels.ERROR, {})
end

_G.notify.shell_error = function()
  return vim.v.shell_error ~= 0
end

_G.bind = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

_G.feedkeys = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

_G.toolbox = function(name, items)
  return function()
    local select_opts = vim.tbl_extend("force", {
      prompt = name,
      format_item = function(command)
        return command.name
      end,
    }, {})

    vim.ui.select(items, select_opts, function(command)
      if command == nil then
        return
      end

      local execute = command.execute
      if type(execute) == "function" then
        local ok, res = pcall(execute)
        if not ok then
          error(res, 0)
        end
      end
    end)
  end
end

-- taken from: https://github.com/Bekaboo/dot/blob/b4f02b7a821a7f43c1175b0588987dd9f94d3efb/.config/nvim/lua/utils/win.lua#L1

---Set window height, without affecting cmdheight
---@param win integer window ID
---@param height integer window height
---@return nil
function M.win_safe_set_height(win, height)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  local winnr = vim.fn.winnr()
  if vim.fn.winnr('j') ~= winnr or vim.fn.winnr('k') ~= winnr then
    local cmdheight = vim.go.cmdheight
    vim.api.nvim_win_set_height(win, height)
    vim.go.cmdheight = cmdheight
  end
end

---Get current 'effective' lines (lines can be used by normal windows)
---@return integer
function M.effective_lines()
  local lines = vim.go.lines
  local ch = vim.go.ch
  local ls = vim.go.ls
  return lines
    - ch
    - (
      ls == 0 and 0
      or (ls == 2 or ls == 3) and 1
      or (
        #vim.tbl_filter(function(win)
              return vim.fn.win_gettype(win) ~= 'popup'
            end, vim.api.nvim_tabpage_list_wins(0))
            > 1
          and 1
        or 0
      )
    )
end

---Returns a function to save some attributes over a list of windows
---@param save_method fun(win: integer): any?
---@param store table<integer, any>
---@return fun(wins: integer[]?): nil
function M.save(save_method, store)
  ---@param wins? integer[] list of wins to restore, default to all windows
  return function(wins)
    for _, win in ipairs(wins or vim.api.nvim_list_wins()) do
      local ok, result = pcall(vim.api.nvim_win_call, win, function()
        return save_method(win)
      end)
      if ok then
        store[win] = result
      end
    end
  end
end

---Returns a function to restore the attributes of windows from `store`
---@param restore_method fun(win: integer, data: any): any?
---@param store table<integer, any>
---@return fun(wins: integer[]?): nil
function M.rest(restore_method, store)
  ---@param wins? integer[] list of wins to restore, default to all windows
  return function(wins)
    if not store then
      return
    end
    for _, win in pairs(wins or vim.api.nvim_list_wins()) do
      if store[win] then
        if not vim.api.nvim_win_is_valid(win) then
          store[win] = nil
        else
          pcall(vim.api.nvim_win_call, win, function()
            restore_method(win, store[win])
          end)
        end
      end
    end
  end
end

---Returns a function to clear the attributes of all windows in `store`
---@param store table<integer, any>
---@return fun(): nil
function M.clear(store)
  return function()
    for win, _ in pairs(store) do
      store[win] = nil
    end
  end
end

local views = {}
local heights = {}

vim.api.nvim_create_autocmd('WinClosed', {
  desc = 'Clear window data when window is closed.',
  group = vim.api.nvim_create_augroup('WinUtilsClearData', {}),
  callback = function(info)
    local win = tonumber(info.match)
    if win then
      views[win] = nil
      heights[win] = nil
    end
  end,
})

_G.win.clearviews = M.clear(views)
_G.win.clearheights = M.clear(heights)

-- stylua: ignore start
_G.win.saveviews = M.save(function(_) return vim.fn.winsaveview() end, views)
_G.win.restviews = M.rest(function(_, view) vim.fn.winrestview(view) end, views)
_G.win.saveheights = M.save(vim.api.nvim_win_get_height, heights)
_G.win.restheights = M.rest(M.win_safe_set_height, heights)
-- stylua: ignore end
