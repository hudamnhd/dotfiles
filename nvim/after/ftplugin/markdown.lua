vim.keymap.set("n", "<space>f", "vipgq", { buffer = true, noremap = true, silent = true })

-- Using `vim.cmd` instead of `vim.wo` because it is yet more reliable
vim.cmd('setlocal wrap')

local has_mini_surround, mini_surround = pcall(require, 'mini.surround')
if has_mini_surround then
  vim.b.minisurround_config = {
    custom_surroundings = {
      -- Bold
      B = { input = { '%*%*().-()%*%*' }, output = { left = '**', right = '**' } },

      -- Link
      L = {
        input = { '%[().-()%]%(.-%)' },
        output = function()
          local link = mini_surround.user_input('Link: ')
          return { left = '[', right = '](' .. link .. ')' }
        end,
      }
    }
  }
end
