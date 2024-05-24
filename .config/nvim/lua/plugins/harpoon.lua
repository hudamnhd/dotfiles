return {
  "ThePrimeagen/harpoon",
  event = { "VimEnter" },
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")
    local Path = require("plenary.path")
    local map = vim.keymap.set

    harpoon:setup()

    harpoon:extend({
      UI_CREATE = function(cx)
        map("n", "h", function()
          harpoon.ui:select_menu_item({})
        end, { buffer = cx.bufnr })
      end,
    })

    local function normalize_path(buf_name, root)
      return Path:new(buf_name):make_relative(root)
    end

    map("n", "sh", function()
      local ui_opts = { ui_fallbkack_width = 4, ui_width_ratio = 0.35 }

      local curr_file = normalize_path(vim.api.nvim_buf_get_name(0), vim.loop.cwd())
      harpoon.ui:toggle_quick_menu(harpoon:list(), ui_opts)

      local cmd = string.format("call search('%s')", curr_file)
      vim.cmd(cmd)
    end)

    map("n", "<leader>a", function() harpoon:list():append() print("Append in harpoon list success") end, { desc = "Append in harpoon" })


    local silent = { silent = true }

      for i = 1, 9 do
        map("n", i .. "h", function() harpoon:list():select(i) end, silent)
      end
  end,
}
