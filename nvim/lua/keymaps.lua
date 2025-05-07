local bind = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local nm, tm, cm, vm, nvm = "n", "t", "c", { "o", "x" }, { "n", "o", "x" }

-- BASIC KEYMAP
bind(tm, [[<c-\>]], [[<C-\><C-n>]])
bind(tm, [[<a-x>]], [[<C-\><C-n>:bd!<Cr>]])
bind(tm, [[<a-w>]], [[<C-\><C-n><c-w>w]])
bind(tm, [[<a-r>]], [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

bind(cm, "<c-v>", [[<C-R>"]], { silent = false })
bind(cm, "<a-v>", [[<C-R>+]], { silent = false })

bind(cm, "<F1>", [[\(.*\)<Left><Left>]], { silent = false })
bind(cm, "<F4>", 'getcmdtype() == ":" ? expand("%:p")  : ""', { silent = false, expr = true })

bind(vm, ">", [[>gv]])
bind(vm, "<", [[<gv]])

bind(nm, "!", [[:<up><cr>]])
bind(nm, "<a-w>", [[<c-w>w]])

bind(nm, "<space>c", vim.cmd.close, { desc = "split" })
bind(nm, "<space>v", vim.cmd.vsplit, { desc = "split" })
bind(nm, "<space>w", vim.cmd.write, { desc = "Write" })
bind(nm, "<space>-", vim.cmd.Git, { desc = "Git" })

bind(nm, "J", [['mz' . v:count1 . 'J`z']], { desc = "Join", expr = true })

bind(nm, "cl", [[mzguiw`z]], { desc = "UPPERCASE to lowercase" })
bind(nm, "ct", [[mzguiwgUl`z]], { desc = "Titlecase" })
bind(nm, "cu", [[mzgUiw`z]], { desc = "lowercase to UPPERCASE" })

bind(nvm, "0", ":", { silent = false })

bind(nvm, "c", [["_c]])
bind(nvm, "x", [["_x]])

bind(nvm, "<space>y", [["+y]], { desc = "Yank to clipboard (primary)" })
bind(nvm, "<space>p", [["+p]], { desc = "Paste after from clipboard (primary)" })

bind(vm, "p", [['pgv"' . v:register . 'y']], { desc = "paste without replacing register", expr = true })

bind(nvm, "<c-z>", [[%]])
bind(nvm, "<c-l>", [[g_]])
bind(nvm, "<c-h>", [[^]])

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

function M.safe()
  M.delete(false)
end

bind(nm, "<space>bq", M.only, { desc = "buffer delete all" })
bind(nm, "<space>bw", M.safe, { desc = "buffer delete" })
bind(nm, "<space>q", M.delete, { desc = "buffer delete" })

local function set_zen_options(enable)
  vim.o.signcolumn    = enable and "no" or "yes"
  vim.opt_local.spell = not enable
  vim.o.wrap          = enable
  vim.o.rnu           = not enable
  vim.o.nu            = not enable
  vim.o.cmdheight     = enable and 0 or 1
end

local function create_window(width, direction)
  vim.api.nvim_command("vsp")
  vim.api.nvim_command("wincmd " .. direction)
  pcall(vim.cmd, "buffer " .. M.buf)
  vim.api.nvim_win_set_width(0, width)

  vim.wo.winfixwidth           = true
  vim.wo.cursorline            = false
  vim.wo.winfixbuf             = true
  vim.o.numberwidth            = 1
  vim.b.ministatusline_disable = true
end

-- like goyo.vim
function M.zenmode(c)
  if M.buf == nil then
    M.buf = vim.api.nvim_create_buf(false, false)
    set_zen_options(true)

    local width = 54 --default width
    if #c.fargs == 1 then
      width = tonumber(c.fargs[1])
    end

    local cur_win = vim.fn.win_getid()
    create_window(width, "H")
    create_window(width, "L")
    vim.api.nvim_set_current_win(cur_win)
  else
    vim.api.nvim_buf_delete(M.buf, { force = true })
    M.buf = nil
    set_zen_options(false)
  end
end

vim.api.nvim_create_user_command("Zenmode", function(c)
  M.zenmode(c)
end, { nargs = "?" })

vim.keymap.set("n", "<F4>", ":Zenmode<CR>")

vim.api.nvim_set_keymap("n", "<space>gc", ":split | terminal commitgen<CR>", { noremap = true, silent = true })
