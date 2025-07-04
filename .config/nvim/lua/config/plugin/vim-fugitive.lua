-- See :help fugitive-commands
local git = {
  git = 'vert Git',
  write = 'Gwrite',
  read = 'Gread',
  vdiff = 'Gvdiffsplit',
  diff = 'Gdiffsplit',
  blame = 'Git blame',
  push = 'Git push',
  pull = 'Git pull',
  pull_rebase = 'Git pull --rebase',
  log_buffer = 'Git log --stat %',
  log_project = 'Git log --stat -n 100',
}

for k, v in pairs(git) do
  git[k] = '<cmd>' .. v .. '<cr>'
end

vim.keymap.set('n', '<Leader>gg', git.git, { desc = 'Git' })
vim.keymap.set('n', '<Leader>gw', git.write, { desc = 'Git write (stage)' })
vim.keymap.set('n', '<Leader>gr', git.read, { desc = 'Git read (reset)' })
vim.keymap.set('n', '<Leader>gv', git.vdiff, { desc = 'Git diff (buffer)' })
vim.keymap.set('n', '<Leader>gl', git.log_buffer, { desc = 'Git log (buffer)' })
vim.keymap.set('n', '<Leader>gL', git.log_project, { desc = 'Git log (project)' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  desc = 'Ensure that fugitive buffers are not listed and are wiped out after hidden.',
  callback = function(info)
    if vim.bo.ft ~= 'fugitive' then return end
    vim.bo[info.buf].buflisted = false
    vim.keymap.set('n', 'q', vim.cmd.bd, { buffer = true })

    vim.keymap.set('n', '<Leader>p', git.push, { buffer = true, desc = 'Git push' })
    vim.keymap.set('n', '<Leader>f', git.pull, { buffer = true, desc = 'Git pull' })
    vim.keymap.set('n', '<Leader>r', git.pull_rebase, { buffer = true, desc = 'Git rebase' }) -- rebase always

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    vim.keymap.set('n', '<Leader>P', ':Git push -u origin ', { silent = false, buffer = true, desc = 'Git push -u origin' })
  end,
})
