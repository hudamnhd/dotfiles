_G.notify = _G.notify or {}
_G.bind = _G.bind or {}
_G.feedkeys = _G.feedkeys or {}

local notify = function(msg, level, opts)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level, opts)
    end)
  else
    vim.notify(msg, level, opts)
  end
end

_G.notify.info = function (msg)
  notify(msg, vim.log.levels.INFO, {})
end

_G.notify.warn = function (msg)
  notify(msg, vim.log.levels.WARN, {})
end

_G.notify.err = function (msg)
  notify(msg, vim.log.levels.ERROR, {})
end

_G.notify.shell_error = function ()
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
