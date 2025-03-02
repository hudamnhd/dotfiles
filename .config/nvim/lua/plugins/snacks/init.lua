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
      toggle.option("wrap", { name = "Wrap" }):map("<space>uw")
      toggle.option("relativenumber", { name = "Relative Number" }):map("<space>uL")
      toggle.diagnostics():map("<space>uD")
      toggle.line_number():map("<space>ul")
      toggle.treesitter():map("<space>uT")
      toggle.indent():map("<space>ug")
    end,
  })
end

function M.config()
  require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = { enabled = true },
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
        wo = { wrap = true }, -- Wrap notifications
      },
    },
    picker = {
      ui_select = false,
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
