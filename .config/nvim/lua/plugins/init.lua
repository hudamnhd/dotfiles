return {
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
      local feedkeys = require("keymaps").feedkeys

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
          -- Default <esc> handler.
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

      -- Rotate visual selection contents.
      set("x", "<leader>t", function()
        mc.transposeCursors(1)
      end)
      set("x", "<leader>T", function()
        mc.transposeCursors(-1)
      end)

      -- Jumplist support
      set({ "x", "n" }, "<c-i>", mc.jumpForward)
      set({ "x", "n" }, "<c-o>", mc.jumpBackward)

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

      -- local function cmdFilePicker(jfind, key)
      --   jfind.findFile({
      --     formatPaths = true,
      --     preview = preview,
      --     previewPosition = "right",
      --     previewPercent = 0.6,
      --     previewMinWidth = 60,
      --     queryPosition = "top",
      --     hidden = true,
      --     callback = {
      --       [key.DEFAULT] = vim.fn.feedkeys,
      --     },
      --   })
      -- end
      --
      -- local function liveGrepPicker(jfind, key)
      --   jfind.liveGrep({
      --     exclude = { ".git" },
      --     include = {},
      --     query = "",
      --     hidden = true,
      --     preview = preview,
      --     previewPosition = "bottom",
      --     queryPosition = "top",
      --     caseSensitivity = "smart",
      --     callback = {
      --       [key.DEFAULT] = jfind.editGotoLine,
      --       [key.CTRL_B] = jfind.splitGotoLine,
      --       [key.CTRL_N] = jfind.vsplitGotoLine,
      --     },
      --   })
      -- end
      --
      -- local function bufferPicker(jfind, key)
      --   local input = table(vim.api.nvim_list_bufs())
      --     :_filter(function(buf)
      --       return vim.api.nvim_buf_is_loaded(buf)
      --     end)
      --     :_map(function(buf)
      --       local name = vim.api.nvim_buf_get_name(buf) or ""
      --       local displayName = name == "" and "[No Name]" or jfind.formatPath(name)
      --       local hint = buf .. " " .. name
      --       return { displayName, hint }
      --     end)
      --     :_flat()
      --
      --   jfind.jfind({
      --     input = input,
      --     hints = true,
      --     formatPaths = true,
      --     showQuery = true,
      --     acceptNonMatch = true,
      --     preview = preview .. " $(echo {} | awk '{$1=\"\"; print $0}')",
      --     previewPosition = "right",
      --     previewPercent = 0.6,
      --     previewMinWidth = 60,
      --     queryPosition = "top",
      --     hidden = true,
      --     callbackWrapper = function(callback, item, query)
      --       item:_split(" "):_get(0):_pipe(callback, query)
      --     end,
      --     callback = {
      --       [key.ESCAPE] = function() end,
      --       [key.DEFAULT] = function(result)
      --         return vim.cmd.buffer(result)
      --       end,
      --       [key.CTRL_B] = function(result)
      --         vim.cmd.split()
      --         vim.cmd.buffer(result)
      --       end,
      --       [key.CTRL_N] = function(result)
      --         vim.cmd.vsplit()
      --         vim.cmd.buffer(result)
      --       end,
      --       [key.CTRL_F] = function(_, query)
      --         filePicker(jfind, key, query)
      --       end,
      --     },
      --   })
      -- end
      -- local function liveGrepQfListPicker()
      --   local jfind = require("jfind")
      --   local Key = require("jfind.key")
      --   jfind.liveGrep({
      --     exclude = { ".git" },
      --     include = {},
      --     query = "",
      --     hidden = true,
      --     preview = preview,
      --     previewPosition = "bottom",
      --     queryPosition = "top",
      --     caseSensitivity = "smart",
      --     selectAll = true,
      --     callback = {
      --       [Key.DEFAULT] = function(results)
      --         table(results)
      --           :_map(function(result)
      --             result = table(result)
      --             return {
      --               filename = result:_get(0),
      --               lnum = result:_get(1),
      --             }
      --           end)
      --           :_pipe(vim.fn.setqflist)
      --         if #results > 0 then
      --           vim.cmd.cc()
      --         end
      --       end,
      --     },
      --   })
      -- end

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
      vim.keymap.set("n", "sp", function()
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
      end)

      -- make sure to rebuld jfind if you want live grep
      vim.keymap.set("n", "si", function()
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
      end)
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
      vim.keymap.set("n", "sn", function()
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
      end)
    end,
  },

  -- ssr
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    -- Calling setup is optional.
    keys = {
      {
        "<space>sr",
        function()
          require("ssr").open()
        end,
        noremap = true,
        mode = { "n", "x" },
      },
    },
    config = function()
      require("ssr").setup({
        min_width = 50,
        min_height = 5,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<C-CR>",
        },
      })
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
  { "mbbill/undotree", event = "BufReadPost" },
  { "haya14busa/vim-edgemotion", event = "BufReadPost" },
}
