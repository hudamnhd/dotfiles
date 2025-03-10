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

-- TrailingWhitespace
augroup("TrailingWhitespace", {
  {
    event = "BufWritePre",
    opts = {
      pattern = "*",
      command = [[%s/\s\+$//e]],
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
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
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
      pattern = "help,man",
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

local function show_file_in_floating_window(file_path)
  -- Cek apakah file ada
  local file = io.open(file_path, "r")
  if not file then
    vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    return
  end
  file:close()

  -- Buat buffer baru
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("syntax", "gitcommit", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "# press 'q' to exit" })

  -- Baca file ke dalam buffer
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! read " .. file_path)
  end)

  -- Bind 'q' untuk menutup window
  vim.keymap.set("n", "q", vim.cmd.q, { buffer = buf })

  -- Cek panjang maksimal dari isi buffer
  local max_width = 0
  local buflines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for _, line in ipairs(buflines) do
    max_width = math.max(max_width, #line)
  end
  max_width = max_width + 2 -- Tambahkan padding

  -- Hitung ukuran window
  local total_width = vim.opt.columns:get()
  local width = math.min(max_width, total_width)

  local total_height = vim.opt.lines:get()
  local height = math.min(#buflines, total_height)

  -- Buka floating window
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (total_width - width) / 2,
    row = 1,
    style = "minimal",
    border = "single",
    noautocmd = false,
  })
end

-- Buat command yang bisa digunakan dengan parameter
vim.api.nvim_create_user_command("ShowFile", function(opts)
  local file_path = opts.args
  show_file_in_floating_window(file_path)
end, {
  nargs = 1, -- Harus ada satu argumen (file path)
  desc = "Menampilkan file dalam floating window",
  complete = "file", -- Auto-complete file path saat mengetik
})
