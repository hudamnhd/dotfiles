local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local cmd = vim.api.nvim_create_user_command

local function T(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local function create_menu(title, lines)
  return Menu({
    relative = "cursor",
    position = {
      row = 1,
      col = 0,
    },
    size = {
      width = 40,
      height = 7,
    },
    border = {
      style = "single",
      text = {
        top = title,
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>", "q" },
      submit = { "<CR>", "<Space>", "l" },
    },
    on_close = function()
      print("Menu Closed!")
    end,
    on_submit = function(item)
      if item.mode == "v" then
        vim.cmd("normal! gv")
      end
      vim.cmd(item.cmd)
    end,
  })
end

local function local_menu()
  -- https://github.com/MunifTanjim/nui.nvim/pull/353/commits/285faf9312adc5de2d6519deebc9f39f470ab726
  local normal_lines = {
    Menu.item("Git", { keymap = "g", cmd = "vert Git" }),
    Menu.item("Gvdiffsplit!", { keymap = "d", cmd = "Gvdiffsplit!" }),
    Menu.item("Git log (Buffer)", { keymap = "l", cmd = "Git log --stat %!" }),
    Menu.item("Git log (Project)", { keymap = "L", cmd = "Git log --stat -n 100" }),
    Menu.item("Commit browser", { keymap = "v", cmd = "GV" }),
    Menu.item("Commit (Buffer)", { keymap = "a", cmd = "GV!" }),
    Menu.item("Commit (Buffer with revision)", { keymap = "r", cmd = "GV?" }),
  }

  create_menu("[Git-Menu]", normal_lines):mount()
end

return local_menu
