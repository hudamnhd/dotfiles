vim.lsp.enable({
  'lua_ls',
})

-- see :help vim.diagnostic.config()
vim.diagnostic.config({
  jump = {
    float = true,
  },
  signs = {
    text = { '󰅚 ', '󰀪 ', '󰋽 ', '󰌶 ' }, -- Error, Warn, Info, Hint
  },
  virtual_text = {
    spacing = 2,
    severity = {
      min = vim.diagnostic.severity.WARN, -- leave out Info & Hint
    },
    format = function(diag)
      local msg = diag.message:gsub('%.$', '')
      return msg
    end,
    suffix = function(diag)
      if not diag then return '' end
      local content = (tostring(diag.code or diag.source or ''))
      if content == '' then return '' end
      return (' [%s]'):format(content:gsub('%.$', ''))
    end,
  },
  float = {
    max_width = 70,
    header = '',
    prefix = function(_, _, total) return (total > 1 and '• ' or ''), 'Comment' end,
    suffix = function(diag)
      local source = (diag.source or ''):gsub(' ?%.$', '')
      local code = diag.code and ': ' .. diag.code or ''
      return ' ' .. source .. code, 'Comment'
    end,
    format = function(diag)
      local msg = diag.message:gsub('%.$', '')
      return msg
    end,
  },

  update_in_insert = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    local ok, fzf = pcall(require, 'fzf-lua')

    if not ok then return end

    vim.keymap.set('n', '<Leader>ca', fzf.lsp_code_actions, { desc = 'Lsp action' })
    vim.keymap.set('n', '<Leader>cf', fzf.lsp_finder, { desc = 'Lsp Finder' })
    vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, { desc = 'Lsp Rename' })
    vim.keymap.set({ 'n', 'x' }, 'gQ', vim.lsp.buf.format, { desc = 'Lsp Format' })

    -- Copy the current line and all diagnostics on that line to system clipboard
    vim.keymap.set('n', 'gyd', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      local line_num = pos[1] - 1 -- 0-indexed
      local line_text = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
      local diagnostics = vim.diagnostic.get(0, { lnum = line_num })
      if #diagnostics == 0 then
        vim.notify('No diagnostic found on this line', vim.log.levels.WARN)
        return
      end
      local message_lines = {}
      for _, d in ipairs(diagnostics) do
        for msg_line in d.message:gmatch('[^\n]+') do
          table.insert(message_lines, msg_line)
        end
      end
      local formatted = {}
      table.insert(formatted, 'Line:\n' .. line_text .. '\n')
      table.insert(formatted, 'Diagnostic on that line:\n' .. table.concat(message_lines, '\n'))
      vim.fn.setreg('+', table.concat(formatted, '\n\n'))
      vim.notify('Line and diagnostic copied to clipboard', vim.log.levels.INFO)
    end, { desc = 'Yank line and diagnostic to system clipboard' })
  end,
})
