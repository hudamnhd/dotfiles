vim.wo.conceallevel = 0
vim.wo.spell        = true
vim.wo.foldexpr     = ""

-- Previm plugin
-- vim.api.nvim_set_keymap('', '<leader>r', "<Esc>:PrevimOpen<CR>",

vim.api.nvim_set_keymap("", "<F12>",
  "<cmd>MarkdownPreviewToggle<CR>",
  { silent = true, desc = "open markdown preview (previm)" })
