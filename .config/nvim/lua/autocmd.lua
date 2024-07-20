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
      pattern = "help,map,markdown,md",
      callback = function()
        local buftype = vim.bo.buftype
        if buftype == "help" or buftype == "nofile" then
          vim.keymap.set("n", "q", "<cmd>bd<cr>", { buffer = true, nowait = true })
          vim.cmd("wincmd H")
        end
      end,
    },
  },
})

-- LSP and formatter mappings
local function lsp_get_clients(...)
  ---@diagnostic disable-next-line: deprecated
  return vim.lsp.get_clients(...) or vim.lsp.get_active_clients(...)
end

augroup("GQFormatter", {
  {
    event = { "FileType", "LspAttach" },
    opts = {
      pattern = "*",
      callback = function(e)
        if e.file:match("^fugitive:") then
          return
        end

        local lsp_has_formatting = false
        local lsp_clients = lsp_get_clients({ bufnr = e.buf })
        local lsp_keymap_set = function(m, c)
          vim.keymap.set(m, "gq", function()
            vim.lsp.buf.format({ async = true, bufnr = e.buf })
          end, {
            silent = true,
            buffer = e.buf,
            desc = string.format("format document [LSP:%s]", c.name),
          })
        end

        vim.tbl_map(function(c)
          if c.supports_method("textDocument/rangeFormatting", { bufnr = e.buf }) then
            lsp_keymap_set("x", c)
            lsp_has_formatting = true
          end
          if c.supports_method("textDocument/formatting", { bufnr = e.buf }) then
            lsp_keymap_set("n", c)
            lsp_has_formatting = true
          end
        end, lsp_clients)

        local ok, conform = pcall(require, "conform")
        local formatters = ok and conform.list_formatters(e.buf) or {}

        if #formatters > 0 then
          vim.keymap.set("n", lsp_has_formatting and "gQ" or "gq", function()
            require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
          end, {
            silent = true,
            buffer = e.buf,
            desc = string.format("format document [%s]", formatters[1].name),
          })
        end
      end,
    },
  },
})

-- Remap ":'<,'>s/" to ":'<,'>s/\%V".
local function map_cmdline_sub()
  local cmd = vim.fn.getcmdline()
  if not cmd:match("^'") then
    return
  end
  local ok, rv = pcall(vim.api.nvim_parse_cmd, cmd, {})
  if not ok or not rv.cmd == "substitute" then
    return
  end
  if cmd:match("'<,'>s[^u ]") then
    vim.fn.setcmdline(cmd .. [[\%V]])
    return true
  end
end
do
  local skip = false
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function()
      skip = false
    end,
  })
  vim.api.nvim_create_autocmd("CmdlineChanged", {
    callback = function()
      if not skip and map_cmdline_sub() then
        skip = true
      end
    end,
  })
end
