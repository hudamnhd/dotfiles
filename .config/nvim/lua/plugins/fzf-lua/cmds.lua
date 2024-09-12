local M = {}
local api, fn, uv = vim.api, vim.fn, vim.loop

function M.mru()
  local current
  if api.nvim_buf_get_option(0, "buftype") == "" then
    current = uv.fs_realpath(api.nvim_buf_get_name(0))
  end

  local files_all = {}
  local files_cwd = {}
  local cwd = vim.fn.expand(vim.uv.cwd())
  local show_all = false

  local mru_files = require("mru").get()

  for _, file in ipairs(mru_files) do
    if file ~= current then
      table.insert(files_all, file)
    end
  end

  local function update_files_cwd()
    files_cwd = {}
    for _, file in ipairs(files_all) do
      local file_absolute_path = vim.fn.fnamemodify(file, ":p")
      if vim.fn.stridx(file_absolute_path, cwd) == 0 then
        local relative_path = vim.fn.fnamemodify(file_absolute_path, ":.")
        table.insert(files_cwd, relative_path)
      end
      -- local file_absolute_path = vim.fn.fnamemodify(file, ":p")
      -- if vim.fn.stridx(file_absolute_path, cwd) == 0 then
      --   table.insert(files_cwd, file)
      -- end
    end
  end

  update_files_cwd()

  local prompt = "MRU"
  prompt = prompt .. " CWD"

  local function show_fzf(files)
    require("fzf-lua").fzf_exec(files, {
      actions = {
        ["default"] = require("fzf-lua").actions.file_edit,
        ["ctrl-h"] = function()
          show_all = not show_all
          if show_all then
            prompt = "MRU ALL"
            show_fzf(files_all)
          else
            prompt = "MRU CWD"
            update_files_cwd()
            show_fzf(files_cwd)
          end
        end,
      },
      fzf_opts = {
        ["--multi"] = "",
      },
      prompt = prompt .. "> ",
      winopts = {
        -- row = 0.85,
        -- col = 0.5,
        height = 0.45,
        width = 0.75,
        preview = { hidden = "hidden" },
      },
    })
  end

  show_fzf(files_cwd)
end

local function handle_delete(path, bookmark_file, resume)
  local lines = {}
  local found = false

  for line in io.lines(bookmark_file) do
    local full_path = vim.fn.expand(line)
    if full_path ~= path then
      table.insert(lines, line)
    else
      found = true
    end
  end

  if found then
    local f = io.open(bookmark_file, "w")
    for _, line in ipairs(lines) do
      f:write(line .. "\n")
    end
    f:close()
    vim.notify("Bookmark deleted: " .. path)
  else
    vim.notify("Bookmark not found:" .. path)
  end
  if resume then
    resume()
  end
end

local function handle_save(path, bookmark_file)
  local f = io.open(bookmark_file, "r")
  if f then
    local exists = false
    for line in f:lines() do
      if line == path then
        exists = true
        break
      end
    end
    f:close()

    if exists then
      handle_delete(path, bookmark_file)
      -- vim.notify("Bookmark already exists")
      return
    end
  end

  f = io.open(bookmark_file, "a")
  f:write(path .. "\n")
  f:close()

  vim.notify("Bookmark saved: " .. path)
end

local function delete_bookmark_file(file, resume)
  local path = vim.fn.fnamemodify(file, ":p")
  local bookmark_file = vim.fn.stdpath("cache") .. "/bookmark"
  handle_delete(path, bookmark_file, resume)
end

local function save_bookmark_file()
  local bookmark_file = vim.fn.stdpath("cache") .. "/bookmark"
  local buffer_path = vim.fn.expand("%:p")
  handle_save(buffer_path, bookmark_file)
end

local function show_bookmark_file()
  local bookmark_file = vim.fn.stdpath("cache") .. "/bookmark"
  local files_all = {}
  local files_cwd = {}
  local cwd = vim.fn.expand(vim.uv.cwd())
  local show_all = false

  for line in io.lines(bookmark_file) do
    local file = vim.fn.expand(line)
    table.insert(files_all, file)
  end

  local function update_files_cwd()
    files_cwd = {}
    for _, file in ipairs(files_all) do
      local file_absolute_path = vim.fn.fnamemodify(file, ":p")
      if vim.fn.stridx(file_absolute_path, cwd) == 0 then
        local relative_path = vim.fn.fnamemodify(file_absolute_path, ":.")
        table.insert(files_cwd, relative_path)
      end
    end
  end

  update_files_cwd()

  local prompt = "B"
  prompt = prompt .. " CWD"

  local function show_fzf(files)
    require("fzf-lua").fzf_exec(files, {
      actions = {
        ["default"] = require("fzf-lua").actions.file_edit,
        ["delete"] = function(selected)
          if selected[1] then
            delete_bookmark_file(selected[1], show_bookmark_file)
          end
        end,
        ["ctrl-h"] = function()
          show_all = not show_all
          if show_all then
            prompt = "B ALL"
            show_fzf(files_all)
          else
            prompt = "B CWD"
            update_files_cwd()
            show_fzf(files_cwd)
          end
        end,
      },
      fzf_opts = {
        ["--multi"] = "",
      },
      prompt = prompt .. "> ",
      winopts = { height = 0.4, width = 0.75 },
    })
  end

  show_fzf(files_cwd)
end

_G.fzf_dirs = function(opts)
  local fzf_lua = require("fzf-lua")
  opts = opts or {}
  opts.prompt = "Directories> "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("cd " .. selected[1])
    end,
  }
  fzf_lua.fzf_exec("fd --type d --hidden ", opts)
end

local function delete_bookmark_dir(file, resume)
  local path = vim.fn.expand(file)
  local bookmark_file = os.getenv("HOME") .. "/.cdg_paths"
  handle_delete(path, bookmark_file, resume)
end

local function show_bookmark_dir()
  local bookmark_file = os.getenv("HOME") .. "/.cdg_paths"
  local files = {}

  for line in io.lines(bookmark_file) do
    local file = vim.fn.expand(line)
    table.insert(files, file)
  end

  local prompt = "DIR"
  prompt = prompt .. " CWD"

  require("fzf-lua").fzf_exec(files, {
    actions = {
      ["default"] = function(selected)
        vim.cmd("F " .. selected[1])
      end,
      ["alt-c"] = function(selected)
        vim.cmd("cd " .. selected[1])
        vim.notify("cwd change to: " .. selected[1])
      end,
      ["delete"] = function(selected)
        if selected[1] then
          delete_bookmark_dir(selected[1], show_bookmark_dir)
        end
      end,
    },
    fzf_opts = {
      ["--multi"] = "",
    },
    prompt = prompt .. "> ",
    winopts = { height = 0.4, width = 0.75 },
  })
end

local function save_bookmark_dir()
  local bookmark_file = os.getenv("HOME") .. "/.cdg_paths"
  local path = vim.fn.expand(vim.uv.cwd())
  handle_save(path, bookmark_file)
end

vim.api.nvim_create_user_command("Cd", function(info)
  _G.fzf_dirs({ cwd = info.fargs[1] })
end, { nargs = "?", complete = "dir", desc = "Fuzzy find Directories." })

-- for file
vim.keymap.set("n", "<space>ba", save_bookmark_file, { desc = "add file bookmark" })
vim.keymap.set("n", "<space>bs", show_bookmark_file, { desc = "show file bookmark" })
vim.keymap.set("n", "<space>be", function() vim.cmd.vsplit(vim.fn.stdpath("cache") .. "/bookmark") end, { desc = "edit file bookmark" })

-- for dir
vim.keymap.set("n", "<space>bA", save_bookmark_dir, { desc = "save dir bookmark" })
vim.keymap.set("n", "<space>bS", show_bookmark_dir, { desc = "show dir bookmark" })
vim.keymap.set("n", "<space>bE", function() vim.cmd.vsplit(os.getenv("HOME") .. "/.cdg_paths") end, { desc = "edit dir bookmark" })

-- stylua: ignore end

return M
