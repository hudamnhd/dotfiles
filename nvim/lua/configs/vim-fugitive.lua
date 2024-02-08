-- Override the default fugitive commands to save the previous buffer
-- before opening the log window.
vim.cmd([[
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gclog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GcLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gllog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GlLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
]])

vim.keymap.set('n', '<leader>g2', '<Cmd>diffget //2<CR>')
vim.keymap.set('n', '<leader>g3', '<Cmd>diffget //3<CR>')

local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local ThePrimeagen_Fugitive =
  vim.api.nvim_create_augroup('ThePrimeagen_Fugitive', {})

autocmd('BufWinEnter', {
  group = ThePrimeagen_Fugitive,
  pattern = '*',
  callback = function()
    -- Check if the buffer file type is "fugitive"
    if vim.bo.ft ~= 'fugitive' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>l", function() vim.cmd("Git pull") end, opts)
      vim.keymap.set("n", "<leader>p", function() vim.cmd("Git push") end, opts)
      vim.keymap.set("n", "gv", function() vim.cmd("GV") end, opts)
      vim.keymap.set("n", "q", function() vim.cmd("bw") end, opts)
    -- stylua: ignore end
  end,
})
