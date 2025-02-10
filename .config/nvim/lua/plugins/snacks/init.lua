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
