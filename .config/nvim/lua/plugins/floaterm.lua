vim.g.floaterm_giteditor = false
vim.g.floaterm_gitcommit = false
vim.g.floaterm_name      = "TERM($1|$2)"
vim.g.floaterm_title     = "TERM($1|$2)"
vim.g.floaterm_opener    = "edit"

vim.cmd("hi FloatermBorder guibg=none guifg=#99d783 ")

local function get_bufnr_from_name(name)
  local buflist = vim.fn["floaterm#buflist#gather"]()
  for _, bufnr in ipairs(buflist) do
    local bufname = vim.fn.getbufvar(bufnr, "floaterm_name")
    if bufname == name then
      return bufnr
    end
  end
  return -1
end

local function toggleFloaterm(args)
  local name = args:match("--name=([^%s]+)")
  local bufnr = get_bufnr_from_name(name)

  if bufnr == -1 then
    vim.cmd("FloatermNew " .. args)
    print("FloatermNew " .. args)
  else
    vim.cmd("FloatermToggle " .. name)
  end
end

return {
  -- Alternate https://github.com/tracyone/term.vim
  "voldikss/vim-floaterm",
  lazy = false,
  config = function()
    -- https://github.com/neovide/neovide/issues/1838
    vim.keymap.set("t", "<MouseMove>", "<NOP>")
        -- stylua: ignore start
        local map  = vim.api.nvim_set_keymap
        local opts = { noremap = true, silent = true }

        map('n', '<space><F1>', ':FloatermNew<CR>',               opts)
        map('n', '<F2>',      ':FloatermPrev<CR>',              opts)
        map('t', '<F2>',      '<C-\\><C-n>:FloatermPrev<CR>',   opts)
        map('n', '<F3>',      ':FloatermNext<CR>',              opts)
        map('t', '<F3>',      '<C-\\><C-n>:FloatermNext<CR>',   opts)
        map('n', '<F1>',       ':FloatermToggle<CR>',            opts) -- easy press
        map('t', '<F1>',       '<C-\\><C-n>:FloatermToggle<CR>', opts) -- easy press
    -- stylua: ignore end

    -- Fungsi untuk membuat perintah Vim
    local function create_command(name, cmd, desc)
      vim.api.nvim_create_user_command(name, cmd, { desc = desc })
    end

    -- stylua: ignore start
      create_command("Gitui",  function() toggleFloaterm("--name=gitui --width=0.9 --height=0.9 --opener=drop gitui") end,     "Gitui")
      create_command("Broot", function() toggleFloaterm("--name=broot --width=0.9 --height=0.9 --opener=edit broot") end,   "Broot")
    -- stylua: ignore end
  end,

  keys = {
        -- stylua: ignore start
        { "<C-G>", function() vim.cmd("Gitui") end, mode = { "n", "t" }, desc = "Gitui" }, -- list fzf_floaterm_newentries
      -- stylua: ignore end
  },
}
