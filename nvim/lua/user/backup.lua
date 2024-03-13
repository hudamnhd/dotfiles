
  {
    "junegunn/fzf",
    enabled = false,
    build = function()
      vim.fn["fzf#install"]()
    end,
  },

  {
    "linrongbin16/fzfx.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },

    -- specify version to avoid break changes
    version = "v5.*",

    config = function()
      require("fzfx").setup()
      -- ======== files ========

-- stylua: ignore start
      -- by args
      vim.keymap.set( "n", "<space>f", "<cmd>FzfxFiles<cr>", { silent = true, noremap = true, desc = "Find files" })
      -- by visual select
      vim.keymap.set("x", "<space>f", "<cmd>FzfxFiles visual<CR>", { silent = true, noremap = true, desc = "Find files" })
      -- by cursor word
      vim.keymap.set("n", "<space>wf", "<cmd>FzfxFiles cword<cr>", { silent = true, noremap = true, desc = "Find files by cursor word" })
      -- by yank text
      vim.keymap.set("n", "<space>pf", "<cmd>FzfxFiles put<cr>", { silent = true, noremap = true, desc = "Find files by yank text" })
      -- by resume
      vim.keymap.set("n", "<space>rf", "<cmd>FzfxFiles resume<cr>", { silent = true, noremap = true, desc = "Find files by resume last" })

      -- ======== live grep ========

      -- live grep
      vim.keymap.set("n", "<space>l", "<cmd>FzfxLiveGrep<cr>", { silent = true, noremap = true, desc = "Live grep" })
      -- by visual select
      vim.keymap.set("x", "<space>l", "<cmd>FzfxLiveGrep visual<cr>", { silent = true, noremap = true, desc = "Live grep" })
      -- by cursor word
      vim.keymap.set("n", "<space>wl", "<cmd>FzfxLiveGrep cword<cr>", { silent = true, noremap = true, desc = "Live grep by cursor word" })
      -- by yank text
      vim.keymap.set("n", "<space>pl", "<cmd>FzfxLiveGrep put<cr>", { silent = true, noremap = true, desc = "Live grep by yank text" })
      -- by resume
      vim.keymap.set("n", "<space>rl", "<cmd>FzfxLiveGrep resume<cr>", { silent = true, noremap = true, desc = "Live grep by resume last" })

      -- ======== buffers ========

      -- by args
      vim.keymap.set("n", "<space>bf", "<cmd>FzfxBuffers<cr>", { silent = true, noremap = true, desc = "Find buffers" })

      -- ======== git files ========

      -- by args
      vim.keymap.set("n", "<space>gf", "<cmd>FzfxGFiles<cr>", { silent = true, noremap = true, desc = "Find git files" })

      -- ======== git live grep ========

      -- by args
      vim.keymap.set("n", "<space>gl", "<cmd>FzfxGLiveGrep<cr>", { silent = true, noremap = true, desc = "Git live grep" })
      -- by visual select
      vim.keymap.set("x", "<space>gl", "<cmd>FzfxGLiveGrep visual<cr>", { silent = true, noremap = true, desc = "Git live grep" })
      -- by cursor word
      vim.keymap.set("n", "<space>wgl", "<cmd>FzfxGLiveGrep cword<cr>", { silent = true, noremap = true, desc = "Git live grep by cursor word" })
      -- by yank text
      vim.keymap.set("n", "<space>pgl", "<cmd>FzfxGLiveGrep put<cr>", { silent = true, noremap = true, desc = "Git live grep by yank text" })
      -- by resume
      vim.keymap.set("n", "<space>rgl", "<cmd>FzfxGLiveGrep resume<cr>", { silent = true, noremap = true, desc = "Git live grep by resume last" })

      -- ======== git changed files (status) ========

      -- by args
      vim.keymap.set("n", "<space>gs", "<cmd>FzfxGStatus<cr>", { silent = true, noremap = true, desc = "Find git changed files (status)" })

      -- ======== git branches ========

      -- by args
      vim.keymap.set("n", "<space>br", "<cmd>FzfxGBranches<cr>", { silent = true, noremap = true, desc = "Search git branches" })

      -- ======== git commits ========

      -- by args
      vim.keymap.set("n", "<space>gc", "<cmd>FzfxGCommits<cr>", { silent = true, noremap = true, desc = "Search git commits" })

      -- ======== git blame ========

      -- by args
      vim.keymap.set("n", "<space>gb", "<cmd>FzfxGBlame<cr>", { silent = true, noremap = true, desc = "Search git blame" })

      -- ======== lsp diagnostics ========

      -- by args
      vim.keymap.set("n", "<space>dg", "<cmd>FzfxLspDiagnostics<cr>", { silent = true, noremap = true, desc = "Search lsp diagnostics" })

      -- ======== lsp symbols ========

      -- lsp definitions
      vim.keymap.set("n", "gd", "<cmd>FzfxLspDefinitions<cr>", { silent = true, noremap = true, desc = "Goto lsp definitions" })

      -- lsp type definitions
      vim.keymap.set("n", "gt", "<cmd>FzfxLspTypeDefinitions<cr>", { silent = true, noremap = true, desc = "Goto lsp type definitions" })

      -- lsp references
      vim.keymap.set("n", "gr", "<cmd>FzfxLspReferences<cr>", { silent = true, noremap = true, desc = "Goto lsp references" })

      -- lsp implementations
      vim.keymap.set("n", "gi", "<cmd>FzfxLspImplementations<cr>", { silent = true, noremap = true, desc = "Goto lsp implementations" })

      -- lsp incoming calls
      vim.keymap.set("n", "gI", "<cmd>FzfxLspIncomingCalls<cr>", { silent = true, noremap = true, desc = "Goto lsp incoming calls" })

      -- lsp outgoing calls
      vim.keymap.set("n", "gO", "<cmd>FzfxLspOutgoingCalls<cr>", { silent = true, noremap = true, desc = "Goto lsp outgoing calls" })

      -- ======== vim commands ========

      -- by args
      vim.keymap.set("n", "<space>cm", "<cmd>FzfxCommands<cr>", { silent = true, noremap = true, desc = "Search vim commands" })

      -- ======== vim key maps ========

      -- by args
      vim.keymap.set("n", "<space>km", "<cmd>FzfxKeyMaps<cr>", { silent = true, noremap = true, desc = "Search vim keymaps" })

      -- ======== file explorer ========

      -- by args
      vim.keymap.set("n", "<space>e", "<cmd>FzfxFileExplorer<cr>", { silent = true, noremap = true, desc = "File explorer" })
      -- stylua: ignore end
    end,
  },

-- {
--   "lifepillar/vim-mucomplete",
-- },

-- {
--   "otavioschwanck/arrow.nvim",
--   opts = {
--     show_icons = true,
--     always_show_path = false,
--     separate_by_branch = false, -- Bookmarks will be separated by git branch
--     hide_handbook = false, -- set to true to hide the shortcuts on menu.
--     save_path = function()
--       return vim.fn.stdpath("cache") .. "/arrow"
--     end,
--     mappings = {
--       edit = "e",
--       delete_mode = "d",
--       clear_all_items = "C",
--       toggle = "s",
--       open_vertical = "v",
--       open_horizontal = "-",
--       quit = "q",
--     },
--     leader_key = "ss",
--     global_bookmarks = false, -- if true, arrow will save files globally (ignores separate_by_branch)
--     index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
--     full_path_list = { "update_stuff" }, -- filenames on this list will ALWAYS show the file path too.
--   },
-- },
-- {
--     "ii14/fzx",
--     config = function()
--     end,
--   },
--   {
--     "kana/vim-textobj-user",
--     event = "VeryLazy",
--     dependencies = { "whatyouhide/vim-textobj-xmlattr" },
--     config = function()
--       vim.cmd([[
-- call textobj#user#plugin('line', {
-- \   '-': {
-- \     'select-a-function': 'CurrentLineA',
-- \     'select-a': 'al',
-- \     'select-i-function': 'CurrentLineI',
-- \     'select-i': 'il',
-- \   },
-- \ })
--
-- function! CurrentLineA()
--   normal! 0
--   let head_pos = getpos('.')
--   normal! $
--   let tail_pos = getpos('.')
--   return ['v', head_pos, tail_pos]
-- endfunction
--
-- function! CurrentLineI()
--   normal! ^
--   let head_pos = getpos('.')
--   normal! g_
--   let tail_pos = getpos('.')
--   let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
--   return
--   \ non_blank_char_exists_p
--   \ ? ['v', head_pos, tail_pos]
--   \ : 0
-- endfunction
--         ]])
--     end,
--   },
