local M = {}

-- stylua: ignore start
M.F         = require("fzf-lua")
M.bind      = require("keymaps").bind
M.winopts   = require("plugins.fzf-lua.layout")
M.mru       = require("plugins.fzf-lua.cmds").mru
M.get_range = require("utils.helper").get_range

M.bind("n", "<leader>lw", function() M.F.lsp_document_diagnostics({ winopts = M.winopts.lg.vertical }) end,   { desc = "Document Diagnostics"  })
M.bind("n", "<leader>lW", function() M.F.lsp_workspace_diagnostics({ winopts = M.winopts.lg.vertical }) end,  { desc = "Workspace Diagnostics"  })
M.bind("n", "<leader>ls", function() M.F.lsp_document_symbols({ winopts = M.winopts.lg.vertical }) end,       { desc = "Document Symbols"  })
M.bind("n", "<leader>lS", function() M.F.lsp_live_workspace_symbols({ winopts = M.winopts.lg.vertical }) end, { desc = "Workspace Symbols"  })

M.bind("n", "sl", function() M.get_range(function(result) M.F.lgrep_curbuf({ winopts = M.winopts.sm.no_preview, query = result }) end) end, { desc = "Grep Buffer"  })
M.bind("n", "sk", function() M.get_range(function(result) M.F.grep({ winopts = M.winopts.sm.no_preview, search = result }) end) end, { desc = "Grep Project"  })
M.bind("x", "sk", function() M.F.grep_visual({ winopts = M.winopts.sm.no_preview }) end, { desc = "Grep Project Selection"  })

M.bind("n", "s/", function() M.F.grep({ winopts = M.winopts.sm.no_preview }) end,            { desc = "Grep"  })

M.bind("n", "ghs", function() M.F.git_status({ winopts = M.winopts.lg.vertical }) end,   { desc = "Status"  })
M.bind("n", "ghb", function() M.F.git_bcommits({ winopts = M.winopts.lg.vertical }) end, { desc = "Bcommits"  })
M.bind("n", "ghc", function() M.F.git_commits({ winopts = M.winopts.lg.vertical }) end,  { desc = "Commits"  })

M.bind("n", "sfm", function() M.F.marks({ winopts = M.winopts.lg.vertical }) end,             { desc = "Marks"  })
M.bind("n", "sfj", function() M.F.jumps({ winopts = M.winopts.lg.vertical }) end,             { desc = "Jumps"  })
M.bind("n", "sfr", function() M.F.registers({ winopts = M.winopts.lg.vertical }) end,         { desc = "Registers"  })
M.bind("n", "sfc", function() M.F.command_history({ winopts = M.winopts.sm.no_preview }) end, { desc = "Command History"  })
M.bind("n", "sfh", function() M.F.changes({ winopts = M.winopts.lg.vertical }) end,           { desc = "changes"  })
M.bind("n", "sfs", function() M.F.search_history({ winopts = M.winopts.sm.no_preview }) end,  { desc = "Search History"  })
M.bind("n", "sfb", function() M.F.buffers({ winopts = M.winopts.sm.no_preview }) end,         { desc = "Buffers"  })
M.bind("n", "sfg", function() M.F.live_grep_resume({ winopts = M.winopts.lg.vertical }) end,  { desc = "Grep Resume"  })
M.bind("n", "sfv", function() M.F.files({ cwd = "~/.config/nvim" }) end, { desc = "VIMRC"  })
M.bind("n", "sfn", function() M.F.files({ cwd = "~/vimwiki" }) end,      { desc = "NOTES"  })
M.bind("n", "sfp", function() M.F.files({ cwd = "%:h" }) end,            { desc = "FILES Sibling" })
M.bind("n", "sff", function() M.F.files({ query = vim.fn.expand("<cword>") }) end, { desc = "Grep files under cursor"  })

M.bind("n", "sp", M.F.files,   { desc = "FILES"  })
M.bind("n", "s0", M.F.resume,  { desc = "RESUME" } )
M.bind("n", "sq", M.F.builtin, { desc = "BUILTIN"  })
M.bind("n", "so", M.mru,       { desc = "OLDFILES" })

M.bind("i", "<c-k>", M.F.complete_path, { desc = "Fuzzy complete path" }) -- remap <C-X><C-F>
M.bind("i", "<c-l>", M.F.complete_line, { desc = "Fuzzy complete line" }) -- remap <C-X><C-L>

M.bind("n", "z=", function() M.F.spell_suggest({ winopts = M.winopts.sm.relative_cursor, }) end, { desc = "spell_suggest" })

vim.api.nvim_create_user_command("F", function(info) M.F.files({ cwd = info.fargs[1] }) end, { nargs = "?", complete = "dir", desc = "Fuzzy find files.", })

M.lsp_attach = function()
  M.bind("n", "<leader>ld", function()
    M.F.lsp_definitions({
      jump_to_single_result = true,
      jump_type = "vsplit",
      winopts = M.winopts.lg.vertical,
    })
  end, { desc = "Go to [D]efinition" })

  M.bind("n", "<leader>lr", function()
    M.F.lsp_references({
      jump_to_single_result = true,
      jump_type = "vsplit",
      multiline = 2,

      winopts = M.winopts.lg.vertical,
    })
  end, { desc = "Go to [R]eferences" })

  M.bind("n", "<leader>la", function() M.F.lsp_code_actions() end, { desc = "[C]ode [A]ction" })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("FzfLuaLspAttachGroup", { clear = true }),
  callback = M.lsp_attach,
})

if vim.fn.has("nvim") == 1 then
  vim.g.terminal_color_0  = "#2A2A37"
  vim.g.terminal_color_1  = "#E78A4E"
  vim.g.terminal_color_2  = "#99c794"
  vim.g.terminal_color_3  = "#fac863"
  vim.g.terminal_color_4  = "#6699cc"
  vim.g.terminal_color_5  = "#c594c5"
  vim.g.terminal_color_6  = "#5fb3b3"
  vim.g.terminal_color_7  = "#c0caf5"
  vim.g.terminal_color_8  = "#555555"
  vim.g.terminal_color_9  = "#FFA066"
  vim.g.terminal_color_10 = "#99c794"
  vim.g.terminal_color_11 = "#fac863"
  vim.g.terminal_color_12 = "#6699cc"
  vim.g.terminal_color_13 = "#c594c5"
  vim.g.terminal_color_14 = "#5fb3b3"
  vim.g.terminal_color_15 = "#c0caf5"
else
  vim.g.terminal_ansi_colors = {
    "#1a1b26", "#ec5f67", "#99c794", "#fac863",
    "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
    "#555555", "#ec5f67", "#99c794", "#fac863",
    "#6699cc", "#c594c5", "#5fb3b3", "#c0caf5",
  }
end
-- stylua: ignore end
