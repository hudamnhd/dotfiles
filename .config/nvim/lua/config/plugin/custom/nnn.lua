--------------------------------------------------------------------------------
-- lua/plugins/custom/nnn.lua
--------------------------------------------------------------------------------
local M = {}

-- NNN: terminal file manager
-- this minimal wrapper use nnn with neovim terminal
-- https://github.com/jarun/nnn/wiki/Usage#from-source
-- Change default map l to open file (like <CR>)

local tmpfile = vim.fn.tempname()

local function is_nnn_available() return vim.fn.executable('nnn') == 1 end
local function is_valid_path(path)
  if not path or path == '' then return false end
  local stat = vim.uv.fs_stat(path)
  return stat and (stat.type == 'file' or stat.type == 'directory')
end

local function build_nnn_cmd(opener)
  local current_file
  if is_valid_path(opener) then
    current_file = opener
  elseif is_valid_path(vim.fn.expand('%:p')) then
    current_file = vim.fn.expand('%:p')
  else
    current_file = vim.loop.cwd()
  end
  local current_dir = vim.fn.expand('%:p:h')
  return string.format('bash -c \'nnn -G -c %s -p "%s" "%s"\'', current_file, tmpfile, current_dir)
end

local function win_spec(spec)
  if spec == 'float' then
    local columns = vim.o.columns
    local lines = vim.o.lines
    local width = math.floor(columns * 0.9)
    local height = math.floor(lines * 0.59)
    return {
      relative = 'editor',
      style = 'minimal',
      row = math.floor((lines - height) * 0.5),
      col = math.floor((columns - width) * 0.5),
      width = width,
      height = height,
      border = 'single',
    }
  else
    return {
      split = 'left',
      width = 35,
      win = 0,
    }
  end
end

local function nnn(path)
  local cmd = build_nnn_cmd(path)
  local previous_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'nnn'

  vim.api.nvim_open_win(buf, true, win_spec('float'))

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, status)
      if vim.api.nvim_win_is_valid(previous_win) then vim.api.nvim_set_current_win(previous_win) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
      if status == 0 then
        if vim.fn.filereadable(tmpfile) == 1 then
          local lines = vim.fn.readfile(tmpfile)
          if #lines > 0 then
            local target_file = lines[1]
            if vim.fn.filereadable(target_file) == 1 then vim.cmd('edit ' .. vim.fn.fnameescape(target_file)) end
          end
        end
      end
    end,
  })
  vim.cmd.startinsert()
end

local function setup()
  vim.cmd('silent! autocmd! FileExplorer *')
  vim.cmd('autocmd VimEnter * ++once silent! autocmd! FileExplorer *')
  -- Disable netrw
  local disabled_built_ins = {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
  }
  for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
  end

  vim.keymap.set('n', '<space>e', nnn, { desc = 'NNN File Manager' })

  -- auto insert mode
  vim.api.nvim_create_autocmd('WinEnter', {
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.bo[buf].buftype == 'terminal' and vim.bo[buf].filetype == 'nnn' then
        if vim.api.nvim_get_mode().mode ~= 'i' then vim.cmd('startinsert') end
      end
    end,
    desc = 'Start insert mode when entering nnn terminal',
  })

  -- helper cmdline :e /lua
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function(ctx)
      local cmdline = vim.fn.getcmdline()
      local cmdtype = vim.fn.getcmdtype()
      local previous = vim.fn.split(cmdline, ' ')
      local previous_cmd = vim.fn.fullcommand(cmdline)

      if cmdtype == ':' and previous_cmd == 'edit' then
        local cwd = vim.loop.cwd()
        local path = previous[2] or cwd

        local stat = vim.loop.fs_stat(path)

        if stat and stat.type == 'directory' then
          vim.schedule(function()
            local buf = vim.api.nvim_get_current_buf()
            pcall(vim.cmd, 'bprevious')
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
            nnn(path)
          end)
          return
        end
      end
    end,
    desc = 'open nnn with e path dir',
  })
end

if is_nnn_available() then
  setup()
else
  -- Ex
  vim.keymap.set('n', '<space>e', vim.cmd.Ex, { desc = 'Open netrw' })
end

return M

--------------------------------------------------------------------------------
