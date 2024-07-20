vim.api.nvim_set_var("dirvish_mode", ":sort ,^.*[\\/],")

local function mappings(event)
  local map = function(mode, lhs, rhs, opts)
    opts = opts or { remap = true, silent = false }
    opts.buffer = event.buf
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- operations
  map("x", "M", [[:Shdo mv {} {}<CR>]])
  map("x", "D", [[:Shdo rm -r {}<CR>]])
  map("x", "Y", [[:Shdo cp -r {} {}<CR>]])
  map("n", "a", [[:!touch <C-R>%]])
  map("n", "A", [[:!mkdir -p <C-R>%]])
  map("n", "t", [[:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd]])
  map("n", "M", [[:!mv <C-R>=substitute(getline(line(".")),"\\n","","g")<CR> <C-R>=substitute(getline(line(".")),"\\n","","g")<CR>]])
  map("n", "Y", [[:!cp -r <C-R>=substitute(getline(line(".")),"\\n","","g")<CR> <C-R>=substitute(getline(line(".")),"\\n","","g")<CR>]])
  map("n", "D", [[:!rm -r <C-R>=substitute(getline(line(".")),"\\n","","g")<CR>]])
  map("n", "X", [[:!trash <C-R>=substitute(getline(line(".")),"\\n","","g")<CR>]])

  -- reload
  map("n", "r", ":<C-U>Dirvish<CR>", { nowait = true })

  -- show hidden
  map("n", "<C-H>", [[:silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>]])

  -- Go up a directory
  map("n", "h", "-^")
  -- Go down a directory / open file
  map("n", "l", "<cr>")
end

local group = vim.api.nvim_create_augroup("dirivsh_cmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "dirvish" },
  desc = "Setup mappings for dirvish",
  callback = mappings,
})

return {
  -- justinmk/vim-dirvish
  { "hudamnhd/vim-dirvish", event = { "VeryLazy" } },
}
