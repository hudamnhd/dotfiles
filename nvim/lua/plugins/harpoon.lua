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

      vim.keymap.set("n", "<space>i", function()
        local ui_opts = {
          ui_fallback_width = 5,
          ui_width_ratio = 0.5,
        }
        local curr_file = normalize_path(vim.api.nvim_buf_get_name(0), vim.loop.cwd())
        harpoon.ui:toggle_quick_menu(harpoon:list(), ui_opts)
        local cmd = string.format("call search('%s')", curr_file)
        vim.cmd(cmd)
      end, { desc = "toggle_quick_menu harpoon" })

      vim.keymap.set("n", "<space>a", function()
        harpoon:list():add()
        vim.notify("harpoon add")
      end, { desc = "Mark harpoon" })

      local keys = '12345'
      for i = 1, #keys do
        local key = keys:sub(i, i)
        local key_combination = string.format('<a-%s>', key)
        vim.keymap.set('n', key_combination, function() harpoon:list():select(i) end, { desc = "Goto harpoon " .. i })
      end
    end,
  },
}
