-------------------------------------------------------------------------------
-- fugitive.vim: A Git wrapper so awesome, it should be illegal
-------------------------------------------------------------------------------
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    augroup('FugitiveSettings', {
      'BufEnter',
      {
        desc = 'Ensure that fugitive buffers are not listed and are wiped out after hidden.',
        pattern = 'fugitive://*',
        callback = function(info)
          vim.bo[info.buf].buflisted = false

          map.n({
            ['q'] = [[!bd]],
            ['<F5>'] = [[!bd]],
            ['<space>p'] = [[!Git push]],
            ['<space>f'] = [[!Git pull]],
            ['<space>r'] = [[!Git pull --rebase]],
          }, { buffer = true })

          map.n('<space>P', [[:Git push -u origin]], { buffer = true, silent = false })

          -- See :help MiniClue.config
          require('mini.clue').setup({
            triggers = {
              { mode = 'n', keys = '<space>' },
            },
            window = {
              -- Show window immediately
              delay = 0,

              config = {
                -- Compute window width automatically
                width = 'auto',

                -- Use double-line border
                border = 'single',
                anchor = 'SW',
                row = 'auto',
                col = 'auto',
              },
            },
          })
        end,
      },
    }, {
      'FileType',
      {
        desc = 'Set buffer-local options for fugitive buffers.',
        pattern = 'fugitive',
        callback = function()
          vim.opt_local.winbar = nil
          vim.opt_local.signcolumn = 'no'
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      },
    }, {
      'FileType',
      {
        desc = 'Set buffer-local options for fugitive blame buffers.',
        pattern = 'fugitiveblame',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.signcolumn = 'no'
          vim.opt_local.relativenumber = false
        end,
      },
    })
  end,
}
