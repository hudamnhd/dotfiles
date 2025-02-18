local M = {}

function M.open_win_partial()
  local file1 = vim.fn.stdpath("config") .. "/lua/plugins/fzf-lua/fzf-lua.lua"
  local file2 = vim.fn.stdpath("config") .. "/lua/keymaps.lua"

  -- Mengambil baris tertentu dari dua file dan menggabungkannya
  local content =
    vim.fn.system(string.format("sed -n '653,713p' %s; echo ''; sed -n '58,170p' %s", file1, file2))
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
local picker_cmds = {
  {
    name = "PICKER scratch buffer",
    execute = function()
      vim.defer_fn(function()
        require("snacks").scratch.select()
      end, 10)
    end,
  },
}

---@type toolbox.Command[]
local toggle_cmds = {
  {
    name = "TOGGLE dim mode",
    execute = function()
      local snacks_dim = require("snacks").dim
      if snacks_dim.enabled then
        snacks_dim.disable()
      else
        snacks_dim.enable()
      end
    end,
  },
  {
    name = "TOGGLE overlay",
    execute = function()
      vim.cmd("lua MiniDiff.toggle_overlay()")
    end,
  },
  {
    name = "TOGGLE hipatterns",
    execute = function()
      vim.cmd("lua MiniHipatterns.toggle()")
    end,
  },
  {
    name = "TOGGLE Undotree",
    execute = function()
      vim.cmd("UndotreeToggle")
    end,
  },
  {
    name = "TOGGLE indent guides",
    execute = function()
      local snacks_indent = require("snacks").indent
      if snacks_indent.enabled then
        snacks_indent.disable()
      else
        snacks_indent.enable()
      end
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

---@type toolbox.Command[]
local utils_cmds = {
  {
    name = "UTILS set cwd",
    execute = function()
      require("utils.helper").set_cwd()
    end,
  },
  {
    name = "UTILS asynctasks",
    execute = function()
      require("plugins.fzf-lua.cmds").asynctasks()

      vim.cmd("startinsert")
    end,
  },
  {
    name = "UTILS rename file",
    execute = function()
      require("snacks").rename.rename_file()
    end,
  },
  {
    name = "UTILS buffer delete all",
    execute = function()
      require("snacks").bufdelete.all()
    end,
  },
  {
    name = "UTILS buffer delete other",
    execute = function()
      require("snacks").bufdelete.other()
    end,
  },
}

---@type toolbox.Command[]
local open_cmds = {
  {
    name = "TEXT keymaps",
    execute = function()
      M.open_win_partial()
    end,
  },
  {
    name = "TEXT vimtutor",
    execute = function()
      M.open_win(vim.fn.stdpath("config") .. "/vimtutor.txt")
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
    name = "GIT lazygit",
    execute = function()
      require("snacks").lazygit()
    end,
  },
  {
    name = "GIT gitbrowse",
    execute = function()
      require("snacks").gitbrowse()
    end,
  },
  {
    name = "GIT fugitive",
    execute = function()
      vim.cmd("vert Git")
    end,
  },
  {
    name = "GIT diffsplit",
    execute = function()
      vim.cmd("Gvdiffsplit!")
    end,
  },
  {
    name = "GIT log buffer",
    execute = function()
      vim.cmd("Git log --stat %!")
    end,
  },
  {
    name = "GIT log project",
    execute = function()
      vim.cmd("Git log --stat -n 100")
    end,
  },
  {
    name = "GIT commit browser",
    execute = function()
      vim.cmd("GV")
    end,
  },
  {
    name = "GIT commit buffer",
    execute = function()
      vim.cmd("GV!")
    end,
  },
  {
    name = "GIT commit buffer withr revision",
    execute = function()
      vim.cmd("GV?")
    end,
  },
}

---@return toolbox.Command[]
function M.all_commands()
  ---@type toolbox.Command[]
  local cmds = {}
  tbl_insert(cmds, picker_cmds)
  -- table.insert(cmds, divider)
  tbl_insert(cmds, toggle_cmds)
  -- table.insert(cmds, divider)
  tbl_insert(cmds, utils_cmds)
  -- table.insert(cmds, divider)
  tbl_insert(cmds, notification_cmds)
  tbl_insert(cmds, git_cmds)
  tbl_insert(cmds, open_cmds)
  return cmds
end

return M
