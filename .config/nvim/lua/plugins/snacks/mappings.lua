---@class toolbox.Command
---@field name string
---@field execute fun()
---
---@class toolbox.finder.Item : snacks.picker.finder.Item
---@field idx number
---@field name string
---@field execute fun()

---@return toolbox.finder.Item[]
local function get_items()
  ---@type toolbox.finder.Item[]
  local items = {}
  local commands = require("plugins.snacks.commands").all_commands()
  for i, v in ipairs(commands) do
    ---@type toolbox.finder.Item
    local item = {
      idx = i,
      text = v.name,
      name = v.name,
      execute = v.execute,
    }
    table.insert(items, item)
  end
  return items
end
local function show_toolbox()
  local items = get_items()
  local select_opts = vim.tbl_extend("force", {
    prompt = "Toolbox",
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
local win = {
  vscode = {
    preview = false,
    layout = {
      backdrop = false,
      row = 0.08,
      width = 0.4,
      min_width = 80,
      height = 0.4,
      min_height = 10,
      box = "vertical",
      border = "rounded",
      title = "{source} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
    },
  },
  vertical = {
    layout = {
      backdrop = false,
      width = 0.7,
      min_width = 80,
      height = 0.8,
      min_height = 30,
      box = "vertical",
      border = "rounded",
      title = "{title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none", height = 0.3 },
      { win = "preview", title = "{preview}", height = 0.5, border = "top" },
    },
  },
}

-- stylua: ignore start
local keys = {
  { "<C-P>",       function() require "snacks".picker({ layout = win.vscode }) end,desc = "Snacks" },
  { "<C-->",       function() require "snacks".explorer() end,                desc = "File Explorer" },
  { "<F7>",        function() require "snacks".scratch() end,                 desc = "Toggle Scratch Buffer" },
  { "<F8>",        function() require "snacks".terminal() end,                desc = "Toggle Terminal", mode = { "n", "t" } },
  { "<a-z>",       function() require "snacks".zen() end,                     desc = "Toggle Zen Mode" },
  { "<space>sp",   function() require "snacks".picker.smart() end,            desc = "Smart Find Files" },
  { "[[",          function() require "snacks".words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  { "]]",          function() require "snacks".words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },
  { "<space>j",    function() show_toolbox() end, desc = "Toolbox", mode = { "n" } },
}
-- stylua: ignore end
for _, m in ipairs(keys) do
  local opts = vim.deepcopy(m)
  opts[1], opts[2], opts.mode = nil, nil, nil
  vim.keymap.set(m.mode or "n", m[1], m[2], opts)
end
