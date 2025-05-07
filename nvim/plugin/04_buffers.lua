local M = {}
local A = vim.api

local notify = function(msg)
  vim.notify("Buffers: " .. msg, vim.log.levels.WARN)
end

local function option(buf, name)
  return A.nvim_get_option_value(name, { buf = buf })
end

local function scratch(win)
  local buf = A.nvim_create_buf(false, true)
  A.nvim_win_set_buf(win, buf)
end

---Remove buffer with save window split and close
function M.delete(force)
  -- Default: force = true
  if force == nil then
    force = true
  end

  local cur_buf = A.nvim_get_current_buf()

  if not option(cur_buf, "buflisted") then
    return
  end

  if not A.nvim_buf_is_loaded(cur_buf) then
    return notify(("Invalid buffer - %s"):format(cur_buf))
  end

  if not force and option(cur_buf, "modified") then
    return notify("Current buffer is modified. Please save it before delete!")
  end

  if not force then
    for _, win in ipairs(A.nvim_list_wins()) do
      if A.nvim_win_is_valid(win) and A.nvim_win_get_buf(win) == cur_buf then
        A.nvim_set_current_win(win)

        local alt_buf = vim.fn.bufnr("#")
        if alt_buf > 0 and A.nvim_buf_is_loaded(alt_buf) then
          A.nvim_set_current_buf(alt_buf)
        else
          pcall(vim.cmd, "bprevious")
        end

        if A.nvim_get_current_buf() == cur_buf then
          scratch(win)
        end
      end
    end
  end

  A.nvim_buf_delete(cur_buf, { force = true })

  notify(("#%s deleted"):format(cur_buf))
end

---Remove all buffers except the current one
function M.only()
  local cur = vim.api.nvim_get_current_buf()

  local deleted, modified = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      modified = modified + 1
    elseif buf ~= cur and vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
      deleted = deleted + 1
    end
  end

  notify(("%s deleted, %s modified"):format(deleted, modified))
end

function M.delsafe()
  M.delete(false)
end

bind("n", "<space>bq", M.only, { desc = "buffer delete all" })
bind("n", "<space>bw", M.delsafe, { desc = "buffer delete save win" })
bind("n", "<space>q", M.delete, { desc = "buffer delete close win" })

