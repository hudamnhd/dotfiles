_G.notify = _G.notify or {}

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
