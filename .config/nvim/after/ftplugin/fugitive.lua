vim.wo.scrolloff = 0
vim.wo.wrap = false
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.linebreak = true
vim.wo.list = false
vim.wo.cursorline = true
vim.wo.spell = false
vim.bo.buflisted = false

vim.keymap.set("n", "q", vim.cmd.bd, { buffer = true })

vim.keymap.set("n", "<space>pp", function()
  vim.cmd.Git("push")
end, { desc = "Git push", buffer = true, nowait = true })

vim.keymap.set("n", "<space>pf", function()
  vim.cmd.Git("pull")
end, { desc = "Git pull", buffer = true })

-- rebase always
vim.keymap.set("n", "<space>pr", function()
  vim.cmd.Git({ "pull", "--rebase" })
end, { desc = "Git pull --rebase", buffer = true })

-- NOTE: It allows me to easily set the branch i am pushing and any tracking
-- needed if i did not set the branch up correctly
vim.keymap.set(
  "n",
  "<space>pt",
  ":Git push -u origin ",
  { desc = "Git push origin", buffer = true }
)
vim.cmd("lua MiniClue.ensure_buf_triggers()")
