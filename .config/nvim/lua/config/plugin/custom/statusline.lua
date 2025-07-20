--------------------------------------------------------------------------------
-- lua/config/plugin/custom/statusline.lua
-- Custom statusline using only builtin APIs and git shell
-- No dependencies required
--------------------------------------------------------------------------------
local api, uv, M = vim.api, vim.uv, {}

local mode_alias = {
  -- Normal modes
  ['n'] = 'Normal',
  ['niI'] = 'Normal',
  ['niR'] = 'Normal',
  ['niV'] = 'Normal',
  ['nt'] = 'Normal',
  -- Visual modes
  ['v'] = 'Visual',
  ['V'] = 'V-Line',
  ['\x16'] = 'V-Block',
  -- Insert modes
  ['i'] = 'Insert',
  ['ic'] = 'Insert',
  -- Replace modes
  ['R'] = 'Replace',
  ['Rv'] = 'V-Replace',
  -- Command-line
  ['c'] = 'Command',
  -- Select mode
  ['s'] = 'Select',
  ['S'] = 'S-Line',
  ['\x13'] = 'S-Block',
  -- Terminal
  ['t'] = 'Terminal',
  -- Ex modes
  ['cv'] = 'Ex',
  ['ce'] = 'Ex',
}

function M.mode()
  local mode = api.nvim_get_mode().mode
  local m = mode_alias[mode] or mode_alias[string.sub(mode, 1, 1)] or 'UNK'
  return m:sub(1, 3):upper()
end

function M.fileinfo() return vim.fn.expand('%:~:.') ~= '' and vim.fn.expand('%:~:.') or '[No Name]' end

function M.filetype() return api.nvim_get_option_value('filetype', { buf = 0 }) .. ' ' end

function M.git_branch()
  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  branch = string.gsub(branch, '\n', '') -- hapus newline

  if branch == '' or branch:match('fatal') then return '' end

  return '[' .. branch .. ']'
end

function M.diagnostic()
  local has_nerd_font = vim.fn.exists('+termguicolors') == 1

  local icons = has_nerd_font and { '󰅚 ', '󰀪 ', '󰋽 ', '󰌶 ' } or { 'E', 'W', 'I', 'H' }

  if not vim.diagnostic.is_enabled({ bufnr = 0 }) or #vim.lsp.get_clients({ bufnr = 0 }) == 0 then return '' end

  local t = {}
  local total = 0
  for i = 1, 4 do
    local count = #vim.diagnostic.get(0, { severity = i })
    if count > 0 then
      total = total + count
      table.insert(t, string.format('%s%d', icons[i], count))
    end
  end

  if total == 0 then return '' end
  return ' ' .. table.concat(t, ' ') .. ' '
end

function M.git_diff()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.fn.isdirectory(file) == 1 then return '' end

  local relpath = vim.fn.fnamemodify(file, ':.')
  local cmd = 'git diff --no-color --unified=0 -- ' .. vim.fn.shellescape(relpath)
  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then return '' end

  local added, removed, changed = 0, 0, 0
  for _, line in ipairs(output) do
    local del_start, del_count, add_start, add_count = line:match('^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@')

    if del_start then
      del_count = tonumber(del_count) or 1
      add_count = tonumber(add_count) or 1

      if del_count > 0 and add_count > 0 then
        changed = changed + math.min(del_count, add_count)
        if del_count > add_count then
          removed = removed + (del_count - add_count)
        elseif add_count > del_count then
          added = added + (add_count - del_count)
        end
      elseif del_count > 0 then
        removed = removed + del_count
      elseif add_count > 0 then
        added = added + add_count
      end
    end
  end

  local t = {}

  if added > 0 then table.insert(t, '+' .. added) end
  if changed > 0 then table.insert(t, '~' .. changed) end
  if removed > 0 then table.insert(t, '-' .. removed) end

  if #t > 0 then
    return (' %s '):format(table.concat(t, ' '))
  else
    return ''
  end
end

function M.eol()
  local is_windows = uv.os_uname().sysname:find('Windows')
  return is_windows and 'dos' or 'unix'
end

function M.encoding() return vim.bo.fileencoding .. ' ' or '' end

function M.lsp_status()
  local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #attached_clients == 0 then return '' end
  local it = vim.iter(attached_clients)
  it:map(function(client)
    local name = client.name:gsub('language.server', 'ls')
    return name
  end)
  local names = it:totable()
  return string.format('%s ', table.concat(names, ', '))
end

local components = {
  " %{v:lua.require'config.plugin.custom.statusline'.mode()}%*",
  ":%{(&modified&&&readonly?'%*':(&modified?'**':(&readonly?'%%':'--')))}",
  ' %P (%#StatusLineNr#%l%*,%02c) ',
  "%{v:lua.require'config.plugin.custom.statusline'.diagnostic()}",
  "%{v:lua.require'config.plugin.custom.statusline'.git_diff()}",
  "%{v:lua.require'config.plugin.custom.statusline'.fileinfo()}",
  "%{v:lua.require'config.plugin.custom.statusline'.git_branch()}",

  ' %=',
  "%{v:lua.require'config.plugin.custom.statusline'.lsp_status()}",
  "%{v:lua.require'config.plugin.custom.statusline'.filetype()}",
  "%{v:lua.require'config.plugin.custom.statusline'.encoding()}",
  "%{v:lua.require'config.plugin.custom.statusline'.eol()} ",
}

function _G._statusline() return table.concat(components) end

vim.opt.statusline = '%{%v:lua._G._statusline()%}'

vim.api.nvim_create_autocmd('UIEnter', {
  desc = 'Setup hl on UIEnter Event ',
  once = true,
  callback = vim.schedule_wrap(
    function() vim.api.nvim_set_hl(0, 'StatusLineNr', { fg = nil, bg = nil, bold = true }) end
  ),
})


return M

--------------------------------------------------------------------------------
