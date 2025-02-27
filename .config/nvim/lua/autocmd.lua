local aucmd = vim.api.nvim_create_autocmd

-- Helper function to create augroup and add autocmds
local function augroup(name, commands)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  for _, cmd in ipairs(commands) do
    aucmd(cmd.event, vim.tbl_extend("force", { group = group }, cmd.opts))
  end
end

-- BufReadPost: Return to last edit position when opening files
augroup("ReturnToLastEditPos", {
  {
    event = "BufReadPost",
    opts = {
      pattern = "*",
      command = [[if line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG' | exe "normal! g`\"" | endif]],
      desc = "Return to last edit position when opening files",
    },
  },
})

-- Highlight yank
augroup("HighlightYank", {
  {
    event = "TextYankPost",
    opts = {
      pattern = "*",
      callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
      end,
    },
  },
})

-- Disable automatic comments on newline
augroup("NewlineNoAutoComments", {
  {
    event = "BufEnter",
    opts = {
      pattern = "*",
      command = "setlocal formatoptions-=o",
    },
  },
})
-- Display help, man in vertical splits and map 'q' to quit
augroup("HelpOpenVert", {
  {
    event = "FileType",
    opts = {
      pattern = "help,man,markdown,md",
      callback = function()
        local buftype = vim.bo.buftype
        if buftype == "help" or buftype == "nofile" then
          vim.keymap.set("n", "q", vim.cmd.bd, { buffer = true, nowait = true })
          vim.cmd("wincmd H")
        end
      end,
    },
  },
})
