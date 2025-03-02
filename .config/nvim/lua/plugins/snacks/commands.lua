local M = {}

function M.open_win_partial()
  local file1 = vim.fn.stdpath("config") .. "/lua/plugins/fzf-lua/fzf-lua.lua"
  local file2 = vim.fn.stdpath("config") .. "/lua/keymaps.lua"

  -- Mengambil baris tertentu dari dua file dan menggabungkannya
  local content =
    vim.fn.system(string.format("sed -n '60,78p' %s; echo ''; sed -n '59,138p' %s", file1, file2))
  -- local content = vim.fn.system(string.format("sed -n '653,713p' %s", file_path))

  require("snacks").win({
    text = content, -- Gunakan `text` untuk memasukkan output langsung
    width = 0.95,
    height = 0.96,
    ft = "lua",
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end

function M.open_win(file_path)
  require("snacks").win({
    file = file_path,
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end

---@param tbl table
---@param insert_tbl table
---@return table
local function tbl_insert(tbl, insert_tbl)
  for _, v in ipairs(insert_tbl) do
    table.insert(tbl, v)
  end
end

---@type toolbox.Command[]
local picker_cmds = {}

---@type toolbox.Command[]
local toggle_cmds = {}

---@type toolbox.Command[]
local utils_cmds = {}

---@type toolbox.Command[]
local open_cmds = {
  {
    name = "TEXT keymaps",
    execute = function()
      M.open_win_partial()
    end,
  },
  {
    name = "TEXT cheatsheet",
    execute = function()
      M.open_win(vim.fn.stdpath("config") .. "/cheatsheet.txt")
    end,
  },
  {
    name = "TEXT panduan_regex_vim",
    execute = function()
      M.open_win(vim.fn.stdpath("config") .. "/panduan_regex_vim.md")
    end,
  },
}

local git_cmds = {
  {
    name = "GIT gitbrowse",
    execute = function()
      require("snacks").gitbrowse()
    end,
  },
}
---@type toolbox.Command[]
local notification_cmds = {
  {
    name = "UTILS show notifications",
    execute = function()
      require("snacks").notifier.show_history()
    end,
  },
  {
    name = "UTILS hide notifications",
    execute = function()
      require("snacks").notifier.hide()
    end,
  },
}

---@return toolbox.Command[]
function M.all_commands()
  ---@type toolbox.Command[]
  local cmds = {}
  tbl_insert(cmds, open_cmds)
  tbl_insert(cmds, picker_cmds)
  tbl_insert(cmds, toggle_cmds)
  tbl_insert(cmds, utils_cmds)
  tbl_insert(cmds, git_cmds)
  tbl_insert(cmds, notification_cmds)
  return cmds
end

return M
