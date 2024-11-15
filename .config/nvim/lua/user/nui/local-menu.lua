local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local cmd = vim.api.nvim_create_user_command

local function T(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

cmd("ReplaceVisualNormal", function()
  local join = T("<C-r>") .. T("<C-w>")
  local left_key = string.rep(T("<left>"), 3)
  vim.api.nvim_feedkeys(":'<,'>s/" .. join .. "/" .. join .. "/gI" .. left_key, "n", false)
end, { desc = "ReplaceVisualNormal" })

cmd("Input", function()
  require("user.nui").local_replace("global")
end, { desc = "Input" })
cmd("InputNormal", function()
  require("user.nui").local_replace("normal")
end, { desc = "Input" })

local function create_menu(title, lines, active_win)
  return Menu({
    relative = "cursor",
    position = {
      row = 1,
      col = 0,
    },
    size = {
      width = 50,
      height = 3,
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
      close = { "<Esc>", "<C-c>", "<C-s>" },
      submit = { "<CR>", "<Space>", "l" },
    },
    on_close = function()
      print("Menu Closed!")
      -- Kembalikan fokus ke window yang aktif sebelumnya
      if active_win then
        vim.api.nvim_set_current_win(active_win)
      end
    end,
    on_submit = function(item)
      if active_win then
        vim.api.nvim_set_current_win(active_win)
      end

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
    Menu.item(":%s/cword//g", { keymap = "s", mode = "n", cmd = "Input" }),
    Menu.item(":s/cword//g", { keymap = "b", mode = "n", cmd = "InputNormal" }),
  }
  local visual_lines = {
    Menu.item(":%s/visual//g", { keymap = "s", mode = "v", cmd = "Input" }),
    Menu.item(":s/cword//g", { keymap = "b", mode = "v", cmd = "InputNormal" }),
  }

  -- Simpan window yang aktif sebelum menu dibuka
  local active_win = vim.api.nvim_get_current_win()

  local lastMode = vim.fn.mode()

  if lastMode == "v" or lastMode == "V" then
    create_menu("[Visual-Mode-Replacer]", visual_lines, active_win):mount()
  else
    create_menu("[Normal-Mode-Replacer]", normal_lines, active_win):mount()
  end
end

return local_menu
