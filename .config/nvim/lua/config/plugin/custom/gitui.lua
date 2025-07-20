-- GITUI: Blazing 💥 fast terminal-ui for git written in rust 🦀
-- https://github.com/gitui-org/gitui/releases/download/v0.27.0/gitui-linux-x86_64.tar.gz
-------------------------------------------------------------------------------
if vim.fn.executable('gitui') == 1 then
  local editor_script = os.getenv('HOME') .. '/.local/bin/nvim-server.sh'

  if vim.fn.filereadable(editor_script) == 0 then
    local f = io.open(editor_script, 'w')
    if not f then return end
    f:write('#!/bin/bash\n')
    f:write('nvim --server "$Nvim" --remote "$1"\n')
    f:close()
    vim.fn.system({ 'chmod', '+x', editor_script })
  end

  local function gitui()
    vim.cmd('tabedit')
    vim.cmd('setlocal nonumber signcolumn=no')

    vim.fn.jobstart('gitui', {
      term = true,
      env = {
        GIT_EDITOR = editor_script,
      },
      on_exit = function()
        vim.cmd('silent! checktime')
        vim.cmd('silent! bw')
      end,
    })

    vim.cmd('startinsert')
  end

  vim.api.nvim_create_user_command('G', gitui, { desc = 'Open Gitui' })
end
