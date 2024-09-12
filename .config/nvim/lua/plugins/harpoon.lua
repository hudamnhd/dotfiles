return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      local extensions = require("harpoon.extensions")

      -- REQUIRED
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            return vim.loop.cwd()
          end,
        },
      })

      harpoon:extend(extensions.builtins.navigate_with_number())

      -- stylua: ignore start
      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "l", function()
            harpoon.ui:select_menu_item({ edit = true })
          end, { buffer = cx.bufnr })
        end,
      })

      local Path = require("plenary.path")
      local function normalize_path(buf_name, root)
        return Path:new(buf_name):make_relative(root)
      end

      vim.keymap.set("n", "m", function()
        local ui_opts = {
          ui_fallback_width = 7,
          ui_width_ratio = 0.7,
        }
        local curr_file = normalize_path(vim.api.nvim_buf_get_name(0), vim.loop.cwd())
        harpoon.ui:toggle_quick_menu(harpoon:list(), ui_opts)
        local cmd = string.format("call search('%s')", curr_file)
        vim.cmd(cmd)
      end, { desc = "toggle_quick_menu harpoon" })

      vim.keymap.set("n", "<space>a", function() harpoon:list():add() vim.notify("harpoon add")end, { desc = "mark harpoon" })

      vim.keymap.set("n", "[a", function() harpoon:list():prev() end)
      vim.keymap.set("n", "]a", function() harpoon:list():next() end)

      -- local keys = '12345'
      -- for i = 1, #keys do
      --   local key = keys:sub(i,i)
      --   local key_combination = string.format('<a-%s>', key)
      --   vim.keymap.set('n', key_combination, function() harpoon:list():select(i) end, { desc = "Goto harpoon " .. i })
      -- end

      -- stylua: ignore end
    end,
  },
  -- {
  --   "j-morano/buffer_manager.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     vim.api.nvim_set_hl(0, "BufferManagerModified", { fg = "#F9AE58" })
  --
  --     vim.cmd([[
  --     autocmd FileType buffer_manager nnoremap <expr> <space> :
  --     ]])
  --   -- stylua: ignore start
  --
  --     local opts = {noremap = true}
  --     local map = vim.keymap.set
  --     -- Setup
  --     require("buffer_manager").setup({
  --       select_menu_item_commands = {
  --         tab = {
  --           key = "<tab>",
  --           command = "edit"
  --         },
  --         l = {
  --           key = "l",
  --           command = "edit"
  --         },
  --         v = {
  --           key = "<C-v>",
  --           command = "vsplit"
  --         },
  --         h = {
  --           key = "<C-h>",
  --           command = "split"
  --         }
  --       },
  --       focus_alternate_buffer = true,
  --       short_file_names = false,
  --       width = 0.7,
  --       height = 0.4,
  --       short_term_names = true,
  --       loop_nav = true,
  --       highlight = 'Normal:BufferManagerBorder',
  --       win_extra_options = {
  --         winhighlight = 'Normal:BufferManagerNormal',
  --       },
  --     })
  --     local bmui = require("buffer_manager.ui")
  --     -- Navigate buffers bypassing the menu
  --     -- Next/Prev
  --     map('n', '<C-Y>', bmui.nav_next, opts)
  --     map('n', '<C-T>', bmui.nav_prev, opts)
  --     -- stylua: ignore end
  --   end,
  -- },
  -- {
  --   "ghillb/cybu.nvim",
  --   -- branch = "main", -- timely updates
  --   branch = "v1.x", -- won't receive breaking changes
  --   event = "VeryLazy",
  --   requires = { "nvim-lua/plenary.nvim" }, -- optional for icon support
  --   config = function()
  --     local ok, cybu = pcall(require, "cybu")
  --     if not ok then
  --       return
  --     end
  --     cybu.setup({
  --       position = {
  --         relative_to = "win", -- win, editor, cursor
  --         anchor = "center", -- topleft, topcenter, topright,
  --         -- centerleft, center, centerright,
  --         -- bottomleft, bottomcenter, bottomright
  --         vertical_offset = -1, -- vertical offset from anchor in lines
  --         horizontal_offset = -1, -- vertical offset from anchor in columns
  --         max_win_height = 5, -- height of cybu window in lines
  --         max_win_width = 0.5, -- integer for absolute in columns
  --         -- float for relative width to win/editor
  --       },
  --       style = {
  --         path = "relative", -- absolute, relative, tail (filename)
  --         path_abbreviation = "none", -- none, shortened
  --         border = "single", -- single, double, rounded, none
  --         separator = " ", -- string used as separator
  --         prefix = "…", -- string prefix for truncated paths
  --         padding = 1, -- left & right padding in nr, of spaces
  --         hide_buffer_id = true, -- hide buffer IDs in window
  --         devicons = {
  --           enabled = false, -- enable or disable web dev icons
  --           colored = false, -- enable color for web dev icons
  --           truncate = false, -- truncate dev icons to one char width
  --         },
  --         highlights = { -- see highlights via :highlight
  --           current_buffer = "CybuFocus", -- current / selected buffer
  --           adjacent_buffers = "LineNr", -- buffers not in focus
  --           background = "CybuBackground", -- the window background
  --           border = "CybuBorder", -- border of the window
  --         },
  --       },
  --       behavior = { -- set behavior for different modes
  --         mode = {
  --           default = {
  --             switch = "immediate", -- immediate, on_close
  --             view = "rolling", -- paging, rolling
  --           },
  --           last_used = {
  --             switch = "on_close", -- immediate, on_close
  --             view = "paging", -- paging, rolling
  --           },
  --           auto = {
  --             view = "rolling",
  --           },
  --         },
  --         show_on_autocmd = false, -- event to trigger cybu (eg. "BufEnter")
  --       },
  --       display_time = 1000, -- time in ms the cybu win is displayed
  --       exclude = { -- filetypes, cybu will not be active
  --         "qf",
  --       },
  --       -- used in excluded filetypes
  --     })
  --     vim.keymap.set("n", "<C-T>", "<Plug>(CybuPrev)")
  --     vim.keymap.set("n", "<C-Y>", "<Plug>(CybuNext)")
  --     vim.keymap.set({ "n", "v" }, "<a-t>", "<plug>(CybuLastusedPrev)")
  --     vim.keymap.set({ "n", "v" }, "<a-y>", "<plug>(CybuLastusedNext)")
  --   end,
  -- },
}
