vim.g.asyncrun_exit = "echo 'Success'"
vim.g.asyncrun_bell = 1
-- vim.g.user_emmet_leader_key = "<C-Z>"
-- vim.g.user_emmet_mode = "i"

return {
  {
    "kana/vim-g",
    lazy = false,
    config = function()
      vim.cmd([[

  " Stage the current file.
        nnoremap <Leader>va <Cmd>call g#vc#add(expand('%'))<CR>

        " Commit the current file.  No need to do git add.
        nnoremap <Leader>vc <Cmd>call g#vc#commit('-v', expand('%'))<CR>

        " Commit all modified files.  No need to do git add.
        nnoremap <Leader>vC <Cmd>call g#vc#commit('-av')<CR>

        " Revert unstaged changes in the current file.
        nnoremap <Leader>vv <Cmd>call g#vc#restore(expand('%'))<CR>

        " Show all uncomitted changes.
        nnoremap <Leader>vD <Cmd>call g#vc#diff('HEAD', '--', '.')<CR>

      ]])

    end,
  },
  {
    "cohama/agit.vim",
    cmd = { "Agit", "AgitFile" },
    config = function() end,
  },
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
      require("live-server").setup()
    end,
  },
  -- install with yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
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
  {
    "haya14busa/vim-edgemotion",
    event = { "BufReadPost" },
    config = function()
      vim.cmd([[
       map <C-J> <Plug>(edgemotion-j)
       map <C-K> <Plug>(edgemotion-k)
       ]])
    end,
  },
  {
    "hudamnhd/search-replace.nvim",
    event = { "BufReadPost" },
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "g",
        -- default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
      vim.o.inccommand = "split"
    end,
  },
  {
    "thinca/vim-partedit",
    keys = { { "<C-e>", ":Partedit -opener vnew -filetype vim -prefix '>'<CR>", mode = { "x" } } },
  },
  {
    "kshenoy/vim-signature",
    event = { "VimEnter" },
    config = function()
      vim.cmd([[ highlight! link SignatureMarkText WarningMsg ]])
    end,
  },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "thinca/vim-quickmemo", event = "VimEnter" },
  { "nicwest/vim-http", ft = "http" },
  { "nvim-lua/plenary.nvim" },
  -- { "mattn/emmet-vim", ft = { "typescriptreact", "javascriptreact", "html", "blade" } },
  -- generate theme bat
  -- {
  --   "linrongbin16/fzfx.nvim",
  --   cmd = { "FzfxFiles" },
  --   dependencies = {
  --     { dir = "~/.fzf", build = ":call fzf#install()" },
  --   },
  --   version = "v5.*",
  --   config = function()
  --     require("fzfx").setup()
  --   end,
  -- },
}
