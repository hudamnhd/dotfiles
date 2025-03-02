local M = {}

function M.show_bookmark_dir()
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
    },
    fzf_opts = {
      ["--multi"] = "",
    },
    prompt = prompt .. "> ",
    winopts = { height = 0.4, width = 0.6 },
  })
end

function M.create_show_toolbox(name, items)
  return function()
    local select_opts = vim.tbl_extend("force", {
      prompt = name,
      format_item = function(command)
        return command.name
      end,
    }, {})

    vim.ui.select(
      items,
      select_opts,
      ---@param command toolbox.Command
      function(command)
        if command == nil then
          return
        end

        local execute = command.execute
        if type(execute) == "function" then
          local ok, res = pcall(execute)
          if not ok then
            error(res, 0)
          end
        end
      end
    )
  end
end

function M.asynctasks()
  local rows = vim.fn["asynctasks#source"](vim.go.columns * 48 / 100)
  require("fzf-lua").fzf_exec(function(cb)
    for _, e in ipairs(rows) do
      local color = require("fzf-lua").utils.ansi_codes
      local line = color.green(e[1]) .. " " .. color.cyan(e[2]) .. ": " .. color.yellow(e[3])
      cb(line)
    end
    cb()
  end, {
    actions = {
      ["default"] = function(selected)
        print(vim.inspect(selected))
        local str = require("fzf-lua").utils.strsplit(selected[1], " ")
        local command = "AsyncTask " .. vim.fn.fnameescape(str[1])
        vim.cmd(command)
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--nth"] = "1",
    },
    winopts = {
      height = 0.6,
      width = 0.6,
    },
  })
end
-- stylua: ignore end

return M
