local M = {}

local function copy(path)
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!', vim.log.levels.INFO)
end

function M.full_path()
  return vim.fn.expand("%:p")
end

function M.full_path_from_home()
  return vim.fn.expand("%:~")
end

function M.file_name()
  return vim.fn.expand("%:t")
end

function M.get_current_relative_path(with_line_number)
  local current_file = vim.fn.expand("%")
  local current_line = vim.fn.line(".")
  local relative_path = vim.fn.fnamemodify(current_file, ":~:.")

  if with_line_number then
    return relative_path .. "#L" .. current_line
  end

  return relative_path
end

M.list_paths = function()
  local fzf = require("fzf-lua")

  function M.file_paths()
    local paths = {
      { type = "Filename", name = M.file_name() },
      { type = "Relative /w Line Number", name = M.get_current_relative_path(true) },
      { type = "Relative", name = M.get_current_relative_path(false) },
      { type = "Full Path (Home)", name = M.full_path_from_home() },
      { type = "Full Path (Absolute)", name = M.full_path() },
    }
    return vim.tbl_filter(function(path)
      return path
    end, paths)
  end

  local results = M.file_paths()

  local entries = {}
  local max_length = 0
  for _, path in ipairs(results) do
    local entry = path.type .. ": " .. path.name
    table.insert(entries, entry)
    if #entry > max_length then
      max_length = #entry
    end
  end

  local win_width = math.min(0.9, (max_length / vim.o.columns) + 0.1)

  local utils = require("fzf-lua.utils")
  local arg_header = function(a_key, d_key, y_key, p_key, a_text, d_text, y_text, p_text)
    a_key = utils.ansi_codes.yellow(a_key)
    d_key = utils.ansi_codes.yellow(d_key)
    y_key = utils.ansi_codes.yellow(y_key)
    p_key = utils.ansi_codes.yellow(p_key)
    return (":: %s to %s, %s to %s, %s to %s, %s to %s"):format(a_key, a_text, d_key, d_text, y_key, y_text, p_key, p_text)
  end

  fzf.fzf_exec(entries, {
    prompt = "Copy File Meta> ",
    previewer = false,
    fzf_opts = {
      ["--header"] = arg_header("a", "d", "y", "p / <c-p>", "touch", "mkdir", "copy", "put"),
    },
    winopts = {
      row = 0.85,
      col = 0.5,
      height = 0.35,
      width = win_width,
      preview = { hidden = "hidden" },
    },
    actions = {
      ["default"] = function(selected)
        local _, path_name = selected[1]:match("^(.-): (.*)$")
        copy(path_name)
        vim.notify('Copied "' .. path_name .. '" to the clipboard!', vim.log.levels.INFO)
      end,
      ["ctrl-p"] = function(selected)
        local _, path_name = selected[1]:match("^(.-): (.*)$")
        vim.api.nvim_paste(path_name, true, -1)
      end,
      ["P"] = function(selected)
        local _, path_name = selected[1]:match("^(.-): (.*)$")
        vim.api.nvim_put({ path_name }, "l", false, false)
      end,
      ["p"] = function(selected)
        local _, path_name = selected[1]:match("^(.-): (.*)$")
        vim.api.nvim_put({ path_name }, "l", true, false)
      end,
      ["f"] = function(selected)
        local path_name = M.full_path()
        local path = vim.fn.fnamemodify(path_name, ":h")
        local cmd = ":!touch " .. path .. "/"
        vim.api.nvim_feedkeys(cmd, "n", true)
      end,
      ["d"] = function(selected)
        local path_name = M.full_path()
        local path = vim.fn.fnamemodify(path_name, ":h")
        local cmd = ":!mkdir " .. path .. "/"
        vim.api.nvim_feedkeys(cmd, "n", true)
      end,
      ["y"] = function(selected)
        local path_name = M.full_path()
        local path = vim.fn.fnamemodify(path_name, ":h")
        local name = vim.fn.fnamemodify(path_name, ":t:r")
        local cmd = ":!cp -p " .. path_name .. " " .. path .. "/" .. name
        vim.api.nvim_feedkeys(cmd, "n", true)
      end,
    },
  })
end

return M
