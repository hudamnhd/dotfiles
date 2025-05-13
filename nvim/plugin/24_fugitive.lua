local groupid = vim.api.nvim_create_augroup('FugitiveSettings', {})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Ensure that fugitive buffers are not listed and are wiped out after hidden.',
  group = groupid,
  pattern = 'fugitive://*',
  callback = function(info)
    vim.bo[info.buf].buflisted = false

    vim.keymap.set("n", "q", vim.cmd.bd, { buffer = true })
    vim.keymap.set("n", "<F5>", vim.cmd.bd, { buffer = true })

    vim.keymap.set("n", "<space>p", function()
      vim.cmd.Git("push")
    end, { desc = "Git push", buffer = true, nowait = true })

    vim.keymap.set("n", "<space>f", function()
      vim.cmd.Git("pull")
    end, { desc = "Git pull", buffer = true })

    -- rebase always
    vim.keymap.set("n", "<space>r", function()
      vim.cmd.Git({ "pull", "--rebase" })
    end, { desc = "Git pull --rebase", buffer = true })

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    vim.keymap.set("n", "<space>P", ":Git push -u origin ", { desc = "Git push origin", buffer = true })


    local miniclue = require("mini.clue")

    -- See :help MiniClue.config
    miniclue.setup({
      triggers = {
        { mode = "n", keys = "<space>" },
      },
      window = {
        delay = 0,
        config = {
          border = "single",
          anchor = "SW",
          width = "auto",
          row = "auto",
          col = "auto",
        },
      },
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set buffer-local options for fugitive buffers.',
  group = groupid,
  pattern = 'fugitive',
  callback = function()
    vim.opt_local.winbar = nil
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set buffer-local options for fugitive blame buffers.',
  group = groupid,
  pattern = 'fugitiveblame',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.relativenumber = false
  end,
})
