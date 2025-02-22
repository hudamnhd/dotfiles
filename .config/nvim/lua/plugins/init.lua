return {

  {
    "linrongbin16/fzfx.nvim",
    -- Optional to avoid break changes between major versions.
    version = "v8.*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },
    config = function()
      require("fzfx").setup()
    end,
  },
  {
    "skywind3000/vim-color-export",
    event = "VeryLazy",
    config = function()
      vim.g.color_export_all = 0
      vim.g.color_export_extra = { "GitGutterAdd", "GitGutterChange", "GitGutterDelete" }
      vim.g.color_export_convert = 1
    end,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = function()
      require("early-retirement").setup({
        retirementAgeMins = 5,
        ignoredFiletypes = { "lazy" },
        notificationOnAutoClose = false,
        ignoreAltFile = true,
        minimumBufferNum = 1,
        ignoreUnsavedChangesBufs = true,
        ignoreSpecialBuftypes = true,
        ignoreVisibleBufs = true,
        ignoreUnloadedBufs = false,
        ignoreFilenamePattern = "",
        deleteBufferWhenFileDeleted = false,
      })
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "BufReadPost",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<a-n>", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "x" }, "<a-s>", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "x" }, "<a-N>", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "x" }, "<a-S>", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add all matches in the document
      set({ "n", "x" }, "<leader>.", mc.matchAllAddCursors)

      -- Delete the main cursor.
      set({ "n", "x" }, "<a-x>", mc.deleteCursor)

      -- Easy way to add and remove cursors using the main cursor.
      set({ "n", "x" }, "<a-c>", mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      set({ "n", "x" }, "<space><a-c>", mc.duplicateCursors)

      set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          vim.cmd("nohlsearch|diffupdate|echo")
        end
      end)

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>gv", mc.restoreCursors)

      -- Split visual selections by regex.
      set("x", "S", mc.splitCursors)

      set("x", "<a-i>", mc.insertVisual)
      set("x", "<a-a>", mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set("x", "m", mc.matchCursors)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "jake-stewart/jfind.nvim",
    branch = "2.0",
    event = "VeryLazy",
    config = function()
      local jfind = require("jfind")
      local key = require("jfind.key")

      jfind.setup({
        exclude = {
          ".git",
          ".idea",
          ".vscode",
          ".sass-cache",
          ".class",
          "__pycache__",
          "node_modules",
          "target",
          "build",
          "tmp",
          "assets",
          "dist",
          "public",
          "*.iml",
          "*.meta",
        },
        windowBorder = true,
        tmux = true,
      })

      -- or you can provide more customization
      -- for more information, read the "Lua Jfind Interface" section
      vim.keymap.set("n", "<space>sp", function()
        jfind.findFile({
          formatPaths = true,
          hidden = true,
          preview = "bat --color always",
          queryPosition = "top",
          previewPosition = "right",
          callback = {
            [key.DEFAULT] = vim.cmd.edit,
            [key.CTRL_S] = vim.cmd.split,
            [key.CTRL_V] = vim.cmd.vsplit,
          },
        })
      end, { desc = "JF find file" })

      -- make sure to rebuld jfind if you want live grep
      vim.keymap.set("n", "<space>si", function()
        jfind.liveGrep({
          hidden = true, -- grep hidden files/directories
          caseSensitivity = "smart", -- sensitive, insensitive, smart
          --     will use vim settings by default
          preview = true,
          previewPosition = "top",
          callback = {
            [key.DEFAULT] = jfind.editGotoLine,
            [key.CTRL_B] = jfind.splitGotoLine,
            [key.CTRL_N] = jfind.vsplitGotoLine,
          },
        })
      end, { desc = "JF live grep" })
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

  { "MunifTanjim/nui.nvim", lazy = true },
  { "stefandtw/quickfix-reflector.vim", ft = "qf" },
  { "LeafCage/yankround.vim", event = "VeryLazy" },
  { "Shougo/unite.vim", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy" },
  { "skywind3000/asyncrun.vim", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "leafgarland/typescript-vim", event = "VeryLazy" },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "BufReadPost" },
  { "mbbill/undotree", event = "BufReadPost" },
  { "haya14busa/vim-edgemotion", event = "BufReadPost" },
}
