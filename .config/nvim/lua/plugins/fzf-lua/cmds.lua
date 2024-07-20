local M = {}

local relative_cursor = {
  relative = "cursor",
  row = 1.01,
  col = 0,
  height = 0.30,
  width = 0.30,
}

function M.complete_path()
  require("fzf-lua").complete_path({
    cmd = "fdfind --type d --type f --exclude .git",
    file_icons = false,
  })
end

function M.grep_curbuf()
  require("fzf-lua").grep_curbuf({ query = vim.fn.expand("<cword>") })
end

function M.spell_suggest()
  local opts_spell = {
    prompt = "Spell> ",
    winopts = relative_cursor,
  }
  require("fzf-lua").spell_suggest(opts_spell)
end

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
        table.insert(files_cwd, file)
      end
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
      winopts = { height = 0.4, width = 0.5 },
    })
  end

  show_fzf(files_cwd)
end

vim.api.nvim_create_user_command("MRU", M.mru, {})

local function delete_bookmark(file)
  local path = vim.fn.expand(file)
  local bookmark_file = vim.fn.stdpath("cache") .. "/bookmark"
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
    vim.notify("Bookmark not found:".. path)
  end
end

local function show_bookmark_list()
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
        ["ctrl-x"] = function(selected)
          if selected[1] then
            delete_bookmark(selected[1])
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
      winopts = { height = 0.4, width = 0.5 },
    })
  end

  show_fzf(files_cwd)
end

local function save_buffer_bookmark()
  local bookmark_file = vim.fn.stdpath("cache") .. "/bookmark"
  local buffer_path = vim.fn.expand("%:p")

  local f = io.open(bookmark_file, "r")
  if f then
    local exists = false
    for line in f:lines() do
      if line == buffer_path then
        exists = true
        break
      end
    end
    f:close()

    if exists then
      vim.notify("Bookmark already exists")
      return
    end
  end

  f = io.open(bookmark_file, "a")
  f:write(buffer_path .. "\n")
  f:close()

  vim.notify("Bookmark saved: " .. buffer_path)
end

-- stylua: ignore start
vim.keymap.set("n", "sB", function() vim.cmd.edit(vim.fn.stdpath("cache") .. "/bookmark") end, { desc = "󰈔 show file bookmark" })
vim.keymap.set("n", "<leader>a",  save_buffer_bookmark,             { desc = "save file bookmark" })
vim.keymap.set("n", "<leader>h",  show_bookmark_list,               { desc = "show file bookmark" })
vim.keymap.set("n", "z=",         M.spell_suggest,                  { desc = "spell_suggest" })
vim.keymap.set("i", "<C-X><C-F>", M.complete_path,                  { desc = "Fuzzy complete path" })
vim.keymap.set("n", "sr",         require("fzf-lua").registers,     { desc = "registers" })
vim.keymap.set("i", "<C-L>",      require("fzf-lua").complete_line, { desc = "Fuzzy complete line" })
-- stylua: ignore end

return M
