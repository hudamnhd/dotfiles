local M = {}

vim.cmd('command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen')
vim.cmd('command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen')

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir

-- Open win quickfix/location list
--------------------------------------------------------------------------------
function M.open_win(type)
  local wininfo = vim.fn.getwininfo()
  local w = { qf = {}, ll = {} }
  for _, win in ipairs(wininfo) do
    if win.loclist == 1 then
      table.insert(w.ll, win.winid)
    elseif win.quickfix == 1 and win.loclist == 0 then
      table.insert(w.qf, win.winid)
    end
  end
  local function close(wins)
    for _, id in ipairs(wins) do
      vim.api.nvim_win_hide(id)
    end
  end
  if type == 'l' then
    if #w.qf > 0 then close(w.qf) end
    -- open all non-empty loclists
    for _, win in ipairs(wininfo) do
      if win.quickfix == 0 then
        if not vim.tbl_isempty(vim.fn.getloclist(win.winnr)) then
          vim.api.nvim_set_current_win(win.winid)
          vim.cmd('lopen')
        else
          vim.notify('loclist is empty.', vim.log.levels.WARN)
        end
        return
      end
    end
  else
    if #w.ll > 0 then close(w.ll) end
    -- open quickfix if not empty
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd('copen')
      vim.g.win_qf = vim.api.nvim_get_current_win()
    else
      vim.notify('quickfix is empty.', vim.log.levels.WARN)
    end
  end
end

vim.keymap.set('n', '<Leader>xq', function() M.open_win('q') end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<Leader>xl', function() M.open_win('l') end, { desc = 'Location List' })

-- Quickfix replace by pattern
--------------------------------------------------------------------------------
function M.qfreplace_by_pattern()
  local word = vim.fn.expand('<cword>')
  local pattern = vim.fn.input('Search pattern: ', word)
  if pattern == '' then
    vim.notify('qfreplace: pattern kosong.', vim.log.levels.WARN)
    return
  end

  local replacement = vim.fn.input('Replace with: ', word)

  local qflist = vim.fn.getqflist()
  local count = 0
  local prev_bufnr = -1
  local qf_was_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'qf' then
      qf_was_open = true
      vim.cmd('cclose')
      break
    end
  end
  local buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch=true]
  local win = vim.api.nvim_open_win(buf, true, {
    split = 'below',
    win = -1,
  })

  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  for _, e in ipairs(qflist) do
    if e.bufnr and e.bufnr ~= 0 and e.lnum then
      if prev_bufnr ~= e.bufnr then
        vim.cmd('buffer ' .. e.bufnr)
        prev_bufnr = e.bufnr
      end

      local line = vim.fn.getline(e.lnum)
      local new_line, n = line:gsub(pattern, replacement)

      if n > 0 and line ~= new_line then
        vim.fn.setline(e.lnum, new_line)
        count = count + 1
      end
    end
  end

  vim.cmd('update')

  if vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_win_close, win, true) end
  if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  -- Update quickfix list dengan line yang baru
  local new_qflist = vim.deepcopy(qflist)
  for _, e in ipairs(new_qflist) do
    if e.bufnr and e.bufnr ~= 0 and e.lnum then
      local line = vim.fn.getbufline(e.bufnr, e.lnum)[1]
      if type(line) == 'string' then e.text = line end
    end
  end
  vim.fn.setqflist(new_qflist, 'r')

  if qf_was_open then vim.cmd('copen') end
  vim.notify(string.format('qfreplace: %d replacement(s) done.', count), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('QfReplacePattern', function() M.qfreplace_by_pattern() end, {})

-- Quickfix replace
-- reference: https://github.com/thinca/vim-qfreplace/blob/master/autoload/qfreplace.vim
--------------------------------------------------------------------------------
M.helper = {}

local buf_nr = -1

-- Buka jendela untuk replace quickfix
function M.qfreplace(cmd) M.helper.open_replace_window(cmd == nil or cmd == '' and 'split' or cmd) end

function M.helper.open_replace_window(cmd)
  if vim.api.nvim_buf_is_loaded(buf_nr) then
    local win = vim.fn.bufwinnr(buf_nr)
    if win >= 0 then
      vim.cmd(win .. 'wincmd w')
    else
      vim.cmd(cmd)
      vim.cmd('buffer ' .. buf_nr)
    end
  else
    vim.cmd(cmd)
    vim.cmd('enew')
    local buf = vim.api.nvim_get_current_buf()
    buf_nr = buf
    vim.bo.swapfile = false
    vim.bo.bufhidden = 'hide'
    vim.bo.buftype = 'acwrite'
    vim.api.nvim_buf_set_name(buf, '[qfreplace]')
    vim.bo.filetype = 'qfreplace'

    vim.api.nvim_create_autocmd('BufWriteCmd', {
      buffer = buf,
      callback = function() M.helper.do_replace() end,
      nested = true,
    })

    local qflist = vim.fn.getqflist()
    vim.b.qfreplace_orig_qflist = qflist

    local current_lines = {}
    for _, e in ipairs(M.helper.get_effectual_lines(qflist)) do
      local text = M.helper.chomp(e.text)
      table.insert(current_lines, text)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, current_lines)
    vim.bo.modified = false
  end
end

function M.helper.do_replace()
  local qf = M.helper.get_effectual_lines(vim.b.qfreplace_orig_qflist)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  if #lines ~= #qf then
    vim.notify(
      string.format('qfreplace: Illegal edit: line number was changed from %d to %d.', #qf, #lines),
      vim.log.levels.ERROR
    )
    return
  end

  vim.bo.modified = false

  local after = 'update' .. (vim.v.cmdbang == 1 and '!' or '')
  if vim.o.hidden and vim.g.qfreplace_no_save == 1 then after = 'if &modified | setlocal buflisted | endif' end

  local prev_bufnr = -1
  for i, e in ipairs(qf) do
    local new_text = lines[i]

    -- Lewati jika tidak ada perubahan
    if e.text ~= new_text then
      -- Berpindah buffer jika perlu
      if prev_bufnr ~= e.bufnr then
        if prev_bufnr ~= -1 then vim.cmd(after) end
        vim.cmd('buffer ' .. e.bufnr)
      end

      local current_line = vim.fn.getline(e.lnum)

      if current_line ~= M.helper.chomp(e.text) then
        if current_line == new_text then
        -- OK: baris sudah berubah tapi cocok dengan teks baru
        else
          vim.notify(
            string.format('qfreplace: Original text has changed: %s:%d', vim.fn.bufname(e.bufnr), e.lnum),
            vim.log.levels.ERROR
          )
        end
      else
        vim.fn.setline(e.lnum, new_text)
        e.text = new_text
      end

      prev_bufnr = e.bufnr
    end
  end

  vim.cmd(after)
  vim.cmd('buffer ' .. buf_nr)

  -- update teks di full qflist, bukan hanya yang effectual
  local new_qflist = vim.deepcopy(vim.b.qfreplace_orig_qflist)
  local new_text_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local i = 1

  for _, e in ipairs(new_qflist) do
    if M.helper.is_effectual_line(e) then
      if i <= #new_text_lines then
        e.text = new_text_lines[i]
        i = i + 1
      end
    end
  end

  vim.fn.setqflist(new_qflist, 'r')
end

function M.helper.get_effectual_lines(qflist) return vim.tbl_filter(M.helper.is_effectual_line, vim.deepcopy(qflist)) end

function M.helper.is_effectual_line(qf) return qf.bufnr ~= nil and qf.bufnr ~= 0 end

function M.helper.chomp(str) return string.gsub(str, '\r?\n?$', '') end

vim.api.nvim_create_user_command(
  'QfReplace',
  function(opts) M.qfreplace(opts.args) end,
  { nargs = '?', complete = 'command' }
)

-- Setup autocmd
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  desc = 'Quicfix replacer',
  callback = function(ctx)
    vim.keymap.set('n', 'r', '<Cmd>Qfreplace<CR>', { buffer = ctx.buf })
    vim.keymap.set('n', '<Leader>r', '<Cmd>QfReplacePattern<CR>', { buffer = ctx.buf })
  end,
})

--------------------------------------------------------------------------------
