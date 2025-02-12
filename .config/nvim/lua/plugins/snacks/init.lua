local M = {
  "folke/snacks.nvim",
  enabled = true,
}

function M.init()
  require("plugins.snacks.mappings")
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      local toggle = require("snacks").toggle
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...)
        require("snacks").debug.inspect(...)
      end
      _G.bt = function()
        require("snacks").debug.backtrace()
      end
      vim.print = _G.dd -- Override print to use snacks for `:=` command

      -- Create some toggle mappings
      toggle.option("spell", { name = "Spelling" }):map("<space>us")
      toggle.option("wrap", { name = "Wrap" }):map("<space>uw")
      toggle.option("relativenumber", { name = "Relative Number" }):map("<space>uL")
      toggle.diagnostics():map("<space>ud")
      toggle.line_number():map("<space>ul")
      toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
        :map("<space>uc")
      toggle.treesitter():map("<space>uT")
      toggle
        .option("background", { off = "light", on = "dark", name = "Dark Background" })
        :map("<space>ub")
      toggle.inlay_hints():map("<space>uh")
      toggle.indent():map("<space>ug")
      toggle.dim():map("<space>uD")
    end,
  })
end

function M.config()
  local layouts = require("snacks.picker.config.layouts")
  for _, k in ipairs({ "default", "vertical" }) do
    layouts[k].layout.width = 0.8
    layouts[k].layout.height = 0.85
  end
  -- layouts.default.layout[1].width = 0.40    -- main win width
  -- layouts.vertical.layout[3].height = 0.45  -- prev win height
  require("snacks").setup({

    ---@type snacks.picker.Config

    bigfile = { enabled = true },

    ---@class snacks.dashboard.Config
    ---@field enabled? boolean
    ---@field sections snacks.dashboard.Section
    ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
    dashboard = {
      enabled = true,
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = ":F",
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua require('plugins.fzf-lua.cmds').mru()",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      -- item field formatters
      formats = {
        icon = function(item)
          if item.file and item.icon == "file" or item.icon == "directory" then
            return M.icon(item.file, item.icon)
          end
          return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
            or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
    picker = {
      ui_select = false,
      -- layout = { preset = "ivy" },
      layout = {
        preset = function()
          return vim.o.columns >= 140 and "default" or "vertical"
        end,
      },
      ---@class snacks.picker.previewers.Config
      previewers = {
        git = { native = true },
      },
      win = {
        input = {
          keys = {
            -- ["<C-y>"] = { function() print("test") end, mode = { "i", "n" } },
            ["<c-d>"] = false,
            ["<c-u>"] = false,
            ["<C-c>"] = { "close", mode = { "i", "n" } },
            ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-p>"] = { "history_back", mode = { "i", "n" } },
            ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<s-up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<s-down>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<F1>"] = { "toggle_help", mode = { "i", "n" } },
            ["<F2>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<F4>"] = { "toggle_preview", mode = { "i", "n" } },
          },
        },
      },
    },
  })
end

return M
