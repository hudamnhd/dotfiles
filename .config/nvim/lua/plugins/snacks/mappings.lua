local function open_win(file_path)
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

-- stylua: ignore start
local keys = {
  { "<C-->",       function() require "snacks".explorer() end,                desc = "File Explorer" },
  { "<C-P>",       function() require "snacks".picker() end,                  desc = "Snacks" },
  { "<F7>",        function() require "snacks".terminal() end,                desc = "which_key_ignore" },
  { "<F8>",        function() require "snacks".terminal() end,                desc = "Toggle Terminal" },
  { "<a-b>",       function() require "snacks".scratch() end,                 desc = "Toggle Scratch Buffer" },
  { "<a-z>",       function() require "snacks".zen() end,                     desc = "Toggle Zen Mode" },
  { "<space><F2>", function() require "snacks".rename.rename_file() end,      desc = "Rename File" },
  { "<space>ba",   function() require "snacks".bufdelete.all() end,           desc = "Delete all buffers" },
  { "<space>bb",   function() require "snacks".scratch.select() end,          desc = "Select Scratch Buffer" },
  { "<space>bq",   function() require "snacks".bufdelete.other() end,         desc = "Delete all buffers except the current one" },
  { "<space>gg",   function() require "snacks".lazygit() end,                 desc = "Lazygit" },
  { "<space>gx",   function() require "snacks".gitbrowse() end,               desc = "Git Browse", mode = { "n", "v" } },
  { "<space>n",    function() require "snacks".notifier.show_history() end,   desc = "Notification History" },
  { "<space>q",    function() require "snacks".bufdelete.delete() end,        desc = "Delete Buffer" },
  { "<space>sp",   function() require "snacks".picker.smart() end,            desc = "Smart Find Files" },
  { "<space>un",   function() require "snacks".notifier.hide() end,           desc = "Dismiss All Notifications" },
  { "[[",          function() require "snacks".words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  { "]]",          function() require "snacks".words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },

  { "<space>C",    function() open_win(vim.fn.stdpath("config") .. "/cheatsheet.txt") end,       desc = "Cheatsheet" },
  { "<space>V",    function() open_win(vim.fn.stdpath("config") .. "/vimtutor.txt") end,         desc = "Vimtutor" },
  { "<space>R",    function() open_win(vim.fn.stdpath("config") .. "/panduan_regex_vim.md") end, desc = "Panduan regex vim" },
}
-- stylua: ignore end
for _, m in ipairs(keys) do
  local opts = vim.deepcopy(m)
  opts[1], opts[2], opts.mode = nil, nil, nil
  vim.keymap.set(m.mode or "n", m[1], m[2], opts)
end
