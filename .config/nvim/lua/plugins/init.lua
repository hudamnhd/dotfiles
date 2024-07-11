return {
  {
    "kana/vim-g",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:g_vc_split_modifier = 'vertical'
        " open file
        nnoremap df :G args

      " Stage the current file.
        nnoremap <Leader>ga <Cmd>call g#vc#add(expand('%'))<CR>

        " Commit the current file.  No need to do git add.
        nnoremap <Leader>gc <Cmd>call g#vc#commit('-v', expand('%'))<CR>

        " Commit all modified files.  No need to do git add.
        nnoremap <Leader>gC <Cmd>call g#vc#commit('-av')<CR>

        " Revert unstaged changes in the current file.
        nnoremap <Leader>gv <Cmd>call g#vc#restore(expand('%'))<CR>

        " Show all uncomitted changes.
        nnoremap <Leader>gD <Cmd>call g#vc#diff('HEAD', '--', '.')<CR>

      ]])
    end,
  },
  {
    "thinca/vim-partedit",
    keys = { { "<CR>", ":Partedit -opener vnew -filetype vimpe -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
      require("live-server").setup()
    end,
  },
  {
    "hudamnhd/search-replace.nvim",
    event = { "BufReadPost" },
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "g",
      })
    end,
  },
  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPost" },
    config = function()
      require("indentmini").setup() -- use default config
      vim.cmd.highlight("IndentLine guifg=#45475a")
      vim.cmd.highlight("IndentLineCurrent guifg=#9CABCA")
    end,
  },
-- stylua: ignore start
  { "cohama/agit.vim",            cmd = { "Agit", "AgitFile" } },
  { "kshenoy/vim-signature",      event = "VeryLazy" },
  { "haya14busa/vim-asterisk",    event = "VeryLazy" },
  { "LeafCage/yankround.vim",     event = "VeryLazy" },
  { "Shougo/unite.vim",           event = "VeryLazy" },
  { "wellle/targets.vim",         event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim",   event = "VeryLazy" },
  { "tpope/vim-eunuch",           event = "VimEnter" },
  { "mbbill/undotree",            event = "BufReadPost" },
  { "haya14busa/vim-edgemotion",  event = "BufReadPost" },
  { "nvim-lua/plenary.nvim" },
  -- stylua: ignore end
  -- { "nvim-tree/nvim-web-devicons" },
}
