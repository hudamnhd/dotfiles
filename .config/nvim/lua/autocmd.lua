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
        local lsp_has_formatting = false
        local lsp_clients = vim.lsp.get_clients({ bufnr = e.buf })

        -- Set up keymap for LSP formatting
        local lsp_keymap_set = function(m, c)
          vim.keymap.set(m, "<space>gq", function()
            vim.lsp.buf.format({ async = true, bufnr = e.buf })
          end, {
            silent = true,
            buffer = e.buf,
            desc = string.format("format document [LSP:%s]", c.name),
          })
        end

        -- Check for LSP formatting capabilities
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

        -- Check if conform is available and list formatters
        local ok, conform = pcall(require, "conform")
        local formatters = ok and conform.list_formatters(e.buf) or {}

        if #formatters > 0 then
          -- Set up keymap for conform formatting
          vim.keymap.set("n", "gq", function()
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

-- https://github.com/neovim/nvim-lspconfig/issues/69#issuecomment-1877781941
-- vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
--   group = vim.api.nvim_create_augroup("user_diagnostic_qflist", {}),
--   callback = function(args)
--     -- Use pcall because I was getting inconsistent errors when quitting vim.
--     -- Possibly timing errors from trying to get/create diagnostics/qflists
--     -- that don't exist anymore. DiagnosticChanged fires at some strange times.
--     local has_diagnostics, diagnostics = pcall(vim.diagnostic.get)
--     local has_qflist, qflist = pcall(vim.fn.getqflist, { title = 0, id = 0, items = 0 })
--     if not has_diagnostics or not has_qflist then
--       return
--     end
--
--     -- Sometimes the event fires with an empty diagnostic list in the data.
--     -- This conditional prevents re-creating the qflist with the same
--     -- diagnostics, which reverts selection to the first item.
--     if
--       #args.data.diagnostics == 0
--       and #diagnostics > 0
--       and qflist.title == "All Diagnostics"
--       and #qflist.items == #diagnostics
--     then
--       return
--     end
--
--     vim.schedule(function()
--       -- If the last qflist was created by this autocmd, replace it so other
--       -- lists (e.g., vimgrep results) aren't buried due to diagnostic changes.
--       pcall(vim.fn.setqflist, {}, qflist.title == "All Diagnostics" and "r" or " ", {
--         title = "All Diagnostics",
--         items = vim.diagnostic.toqflist(diagnostics),
--       })
--
--       -- Don't steal focus from other qflists. For example, when working
--       -- through vimgrep results, you likely want :cnext to take you to the
--       -- next match, rather than the next diagnostic. Use :cnew to switch to
--       -- the diagnostic qflist when you want it.
--       if qflist.id ~= 0 and qflist.title ~= "All Diagnostics" then
--         pcall(vim.cmd.cold)
--       end
--     end)
--   end,
-- })
