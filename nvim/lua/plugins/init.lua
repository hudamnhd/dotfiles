return {
  {
    "dyng/ctrlsf.vim",
    event = { "BufReadPost" },
    config = function()
      vim.g.ctrlsf_mapping = {
        open = { "<CR>", "o" },
        openb = "O",
        split = "<C-O>",
        vsplit = "",
        tab = "t",
        tabb = "T",
        popen = "p",
        popenf = "P",
        quit = "q",
        next = "<C-J>",
        prev = "<C-K>",
        nfile = "<C-N>",
        pfile = "<C-P>",
        pquit = "q",
        loclist = "",
        chgmode = "<TAB>",
        stop = "<C-C>",
      }
      vim.cmd([[
        nmap     sr <Plug>CtrlSFCwordPath<CR>
        vmap     sr <Plug>CtrlSFVwordExec
        nnoremap se :CtrlSFToggle<CR>
       ]])
    end,
  },
  {
    "cohama/agit.vim",
    keys = "<a-g>", -- tester
    config = function()
      vim.keymap.set("n", "<a-g>", "<CMD>Agit<CR>")
    end,
  },
  {
    "cohama/lexima.vim",
    event = { "BufReadPost" },
  },
  { "wellle/targets.vim", event = "VeryLazy" },
  {
    "RRethy/nvim-align",
    event = { "BufReadPost" },
    config = function()
      -- :'<,'>Align regex_pattern.*
      -- :'<,'>Align =
      -- :Align x\s*=
      vim.keymap.set("v", "<C-N>", ":Align<space>")
    end,
  },
  {
    "haya14busa/vim-edgemotion",
    event = "VeryLazy", -- tester
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
    "AndrewRadev/simple_bookmarks.vim",
    event = { "VimEnter" },
    config = function()
      vim.keymap.set("n", "sm", ":BookmarkAdd<space>")
    end,
  },
  {
    "thinca/vim-partedit",
    event = { "BufReadPost" },
    config = function()
      vim.keymap.set({ "x" }, "<c-e>", ":Partedit -opener new -filetype vim -prefix '>'<CR>")
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    cmd = { "ColorizerToggle" },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      { "junegunn/fzf", build = ":call fzf#install()" },
    },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
          show_title = false,
          should_preview_cb = function(bufnr)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
              -- skip file size greater than 100k
              ret = false
            elseif bufname:match("^fugitive://") then
              -- skip fugitive buffer
              ret = false
            end
            return ret
          end,
        },
        -- make `drop` and `tab drop` to become preferred
        func_map = {
          drop = "o",
          openc = "O",
          split = "<C-s>",
          tabdrop = "<C-t>",
          -- set to empty string to disable
          tabc = "",
          ptogglemode = "z,",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  {
    "kshenoy/vim-signature",
    event = { "VimEnter" },
    config = function()
      vim.cmd([[ highlight! link SignatureMarkText WarningMsg ]])
    end,
  },
  {
    "thinca/vim-qfreplace",
    keys = { "<A-r>" },
    config = function()
      vim.keymap.set("n", "<A-r>", "<CMD>Qfreplace<CR>")
    end,
  },
  {
    "kana/vim-niceblock",
    event = { "BufReadPost" },
  },
  {
    "thinca/vim-quickmemo",
    event = { "VimEnter" },
  },
  {
    "LeafCage/yankround.vim",
    event = { "BufReadPost" },
    dependencies = {
      {
        "Shougo/unite.vim",
        event = { "BufReadPost" },
        config = function() end,
      },
    },
    config = function()
      vim.keymap.set("n", "sy", "<CMD>Unite yankround<CR>")
    end,
  },
  {
    "RRethy/vim-indexor",
    lazy = false,
  },
  {
    "nvim-lua/plenary.nvim",
  },
  -- {
  --   "RRethy/nvim-base16",
  --   priority = 1000,
  -- },
  -- {
  --   "nvim-focus/focus.nvim",
  --   version = "*",
  --   event = "VeryLazy", -- tester
  --   config = function()
  --     require("focus").setup()
  --   end,
  -- },
}
