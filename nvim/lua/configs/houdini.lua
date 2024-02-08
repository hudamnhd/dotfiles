require('houdini').setup({
  mappings = { 'jj', 'AA', 'II' },
  timeout = vim.o.timeoutlen,
  check_modified = true,
  escape_sequences = {
    ['i'] = function(first, second)
      local seq = first .. second

      if seq == 'AA' then
        -- jump to the end of the line in insert mode
        return '<BS><BS><End>'
      end

      if seq == 'II' then
        -- jump to the beginning of the line in insert mode
        return '<BS><BS><Home>'
      end
      -- occasions by simply returning an empty string
      if vim.opt.filetype:get() == 'fzf' then
        return '<BS><BS><C-\\><C-n>'
      end
      return '<BS><BS><ESC>'
    end,
    ['t'] = function()
      return ''
    end,
  },
})
