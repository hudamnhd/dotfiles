return {
  {
    "thinca/vim-partedit",
    keys = { { "<CR>", ":Partedit -opener vnew -filetype vimpe -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "kassio/neoterm",
    cmd = "T",
    config = function()
      -- Enable bracketed paste
      vim.g.neoterm_bracketed_paste = 1
      -- Don't add extra call to REPL when sending
      vim.g.neoterm_direct_open_repl = 1
      -- Open terminal to the right by default
      vim.g.neoterm_default_mod = "vertical"
      -- Go into insert mode when terminal is opened
      vim.g.neoterm_autoinsert = 1
      -- Scroll to recent command when it is executed
      vim.g.neoterm_autoscroll = 1
      -- Don't automap keys
      pcall(vim.keymap.del, "n", ",tt")
    end,
  },
  {
    "danymat/neogen",
    event = "BufReadPost",
    config = function()
      require("neogen").setup({})
      local opts = { noremap = true, silent = true, desc = "Neogen generate" }
      vim.api.nvim_set_keymap("n", "<space>tg", ":lua require('neogen').generate()<CR>", opts)
    end,
  },
  {
    "ii14/neorepl.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<space>0", function()
        -- get current buffer and window
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        -- create a new split for the repl
        vim.cmd("split")
        -- spawn repl and set the context to our buffer
        require("neorepl").new({
          lang = "vim",
          buffer = buf,
          window = win,
        })
        -- resize repl window and make it fixed height
        vim.cmd("resize 10 | setl winfixheight")
      end, { desc = "neorepl" })
    end,
  },
  {
    "haya14busa/vim-edgemotion",
    event = "BufReadPost",
    config = function()
      vim.cmd([[
    map <C-J> <Plug>(edgemotion-j)
    map <C-K> <Plug>(edgemotion-k)
    ]])
    end,
  },
  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "LeafCage/yankround.vim", event = "VeryLazy" },
  { "Shougo/unite.vim", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "BufReadPost" },
  { "mbbill/undotree", event = "BufReadPost" },
}
