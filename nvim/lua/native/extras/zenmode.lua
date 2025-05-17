-------------------------------------------------------------------------------
-- Zenmode ====================================================================
-------------------------------------------------------------------------------
local z = {}

local function set_zen_options(enable)
  vim.o.signcolumn = enable and 'no' or 'yes'
  vim.opt_local.spell = not enable
  vim.o.wrap = enable
  vim.o.rnu = not enable
  vim.o.nu = not enable
  vim.o.cmdheight = enable and 0 or 1
  vim.o.laststatus = enable and 0 or 2
end

local function create_window(width, direction)
  vim.api.nvim_command('vsp')
  vim.api.nvim_command('wincmd ' .. direction)
  pcall(vim.cmd, 'buffer ' .. z.buf)
  vim.api.nvim_win_set_width(0, width)

  vim.wo.winfixwidth = true
  vim.wo.cursorline = false
  vim.wo.winfixbuf = true
  vim.o.numberwidth = 1
end

function z.zenmode(c)
  if z.buf == nil then
    z.buf = vim.api.nvim_create_buf(false, false)
    set_zen_options(true)

    local width = 54 --default width
    if #c.fargs == 1 then width = tonumber(c.fargs[1]) end

    local cur_win = vim.fn.win_getid()
    create_window(width, 'H')
    create_window(width, 'L')
    vim.api.nvim_set_current_win(cur_win)
  else
    vim.api.nvim_buf_delete(z.buf, { force = true })
    z.buf = nil
    set_zen_options(false)
  end
end

vim.api.nvim_create_user_command('Zenmode', function(c) z.zenmode(c) end, { nargs = '?' })
