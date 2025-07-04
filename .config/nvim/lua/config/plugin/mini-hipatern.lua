return {
  module = 'mini.hipatterns',
  config = function()
    -- See :help MiniHipatterns-examples
    local hipatterns = require('mini.hipatterns')
    local hi_words = require('mini.extra').gen_highlighter.words
    hipatterns.setup({
      highlighters = {
        fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })

    vim.keymap.set('n', '<Leader>cc', '<Cmd>lua MiniHipatterns.toggle()<CR>', { desc = 'Code Colorizer' })
  end,
}
