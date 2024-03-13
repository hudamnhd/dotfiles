local api, fn = vim.api, vim.fn
local define = api.nvim_create_user_command

local CMD = ([[cnorea <expr> %s getcmdtype() == ':' && getcmdline() ==# '%s' ? '%s' : '%s']])
-- local function abbrev(lhs, rhs)
--   api.nvim_command(CMD:format(lhs, lhs, rhs, lhs))
-- end

-- Delete buffers without changing window layout
define('Bd', function(ctx)
  local err = require('utils.m.cmd.bd').bd(ctx.args, ctx.bang)
  if err then api.nvim_err_writeln(err) end
end, { bang = true, nargs = '?', complete = 'buffer' })
define('Bw', function(ctx)
  local err = require('utils.m.cmd.bd').bw(ctx.args, ctx.bang)
  if err then api.nvim_err_writeln(err) end
end, { bang = true, nargs = '?', complete = 'buffer' })
define('Bq', [[
  if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'term_closed', 1) == 0 |
    bd! |
  else |
    bd<bang> <args> |
  endif
]], { bang = true, nargs = '?', complete = 'buffer' })
-- abbrev('bd', 'Bd')
-- abbrev('bw', 'Bw')
-- abbrev('bq', 'Bq')


