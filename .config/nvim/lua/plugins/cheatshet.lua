local M = { "smartinellimarco/nvcheatsheet.nvim" }

M.opts = {
  -- Default header
  header = {
    "                                      ",
    "                                      ",
    "                                      ",
    "█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
    "█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
    "                                      ",
    "                                      ",
    "                                      ",
  },
  -- Example keymaps (this doesn't create any)
  keymaps = {
    ["Fzflua"] = {
      { "Buffers", "^b" },
      { "Changes", "s;" },
      { "Cmd History", "s0" },
      { "Daily notes", "<space>l" },
      { "Daily notes", "<space>n" },
      { "Files", "sp" },
      { "Git BCommits", "sgb" },
      { "Git Commits", "sgc" },
      { "Git Status", "gp" },
      { "Grep Buffer (cword)", "sl" },
      { "Grep Project (cword) / (selection)", "sk" },
      { "Grep Resume", "s/" },
      { "Grep file under cursor", "sqf" },
      { "Grep prompt buffer input", "<space>o" },
      { "Grep prompt project input", "<space>i" },
      { "List Path Buffer", "sqb" },
      { "Mru", "so" },
      { "Nvim config", "sqv" },
      { "Register", "s'" },
      { "Search History", "sh" },
      { "Spell Suggest", "z=" },
      { "Vimwiki", "sqn" },
    },
  },
}

M.palette = {
  red = 0xfdba74,
  green = 0xa3e635,
  yellow = 0xfde047,
  orange = 0xf472b6,
  orange = 0xfda4af,
  blue = 0x93c5fd,
  purple = 0xf0abfc,
  cyan = 0xa5b4fc,
  white = 0xd1d5db,
  fg = 0xd1d5db,
  black = 0x1f2937,
  bg = 0x1f2937,
}

M.keys = { "<F12>" }
function M.config(_, opts)
  local nvcheatsheet = require("nvcheatsheet")

  nvcheatsheet.setup(opts)

  -- You can also close it with <Esc>
  vim.keymap.set("n", "<F12>", nvcheatsheet.toggle)
end

return M

-- vim: ts=2 sts=2 sw=2 et
