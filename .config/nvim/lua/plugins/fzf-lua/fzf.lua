local M = {}

M.winopts = {
  sm = {
    no_preview = {
      -- row = 0.85,
      -- col = 0.5,
      height = 0.45,
      width = 0.75,
      preview = { hidden = "hidden" },
    },
    relative_cursor = {
      relative = "cursor",
      row = 1.01,
      col = 0,
      height = 0.30,
      width = 0.30,
    },
  },
  md = {
    flex = {
      height = 0.65,
      width = 0.65,
      preview = {
        layout = "flex",
        vertical = "up:50%",
      },
    },
  },
  lg = {
    flex = {
      height = 0.9,
      width = 0.9,
      preview = {
        layout = "flex",
        vertical = "up:65%", -- up|down:size
        horizontal = "left:50%", -- right|left:size
      },
    },
    vertical_corner = {
      row = 0.85,
      col = 1,
      height = 0.9,
      width = 85,
      preview = {
        layout = "vertical",
        vertical = "up:65%", -- up|down:size
      },
    },
    vertical = {
      height = 0.95,
      width = 0.95,
      preview = {
        layout = "vertical",
        vertical = "up:65%", -- up|down:size
      },
    },
  },
  fullscreen = {
    flex = {
      fullscreen = true,
      preview = {
        layout = "flex",
        vertical = "up:65%", -- up|down:size
        horizontal = "left:50%", -- right|left:size
      },
    },
    vertical = {
      fullscreen = true,
      preview = {
        layout = "vertical",
        vertical = "up:65%",
      },
    },
  },
}

-- stylua: ignore start
local F = require("fzf-lua")
M.bind  = require("keymaps").bind
M.mru   = require("plugins.fzf-lua.cmds").mru
M.cword = vim.fn.expand("<cword>")


M.bind("n", "<leader>ld", function() F.lsp_document_diagnostics({ winopts = M.winopts.lg.vertical }) end,   { desc = "Document Diagnostics"  })
M.bind("n", "<leader>lw", function() F.lsp_workspace_diagnostics({ winopts = M.winopts.lg.vertical }) end,  { desc = "Workspace Diagnostics"  })
M.bind("n", "<leader>ls", function() F.lsp_document_symbols({ winopts = M.winopts.lg.vertical }) end,       { desc = "Document Symbols"  })
M.bind("n", "<leader>lS", function() F.lsp_live_workspace_symbols({ winopts = M.winopts.lg.vertical }) end, { desc = "Workspace Symbols"  })


M.bind("n", "s8", function() F.lgrep_curbuf({ winopts = M.winopts.sm.no_preview, query = cword  }) end, { desc = "Grep Current File"  })

M.bind("n", "sk", function() F.grep_cword({ winopts = M.winopts.sm.no_preview }) end,      { desc = "Grep Project Cword"  })
M.bind("x", "sk", function() F.grep_visual({ winopts = M.winopts.sm.no_preview }) end,     { desc = "Grep Project Selection"  })
M.bind("n", "sh", function() F.search_history({ winopts = M.winopts.sm.no_preview }) end,  { desc = "Search History"  })
M.bind("n", "sx", function() F.command_history({ winopts = M.winopts.sm.no_preview }) end, { desc = "Commands History"  })
M.bind("n", "sg", function() F.grep({ winopts = M.winopts.sm.no_preview }) end,            { desc = "Grep"  })
M.bind("n", "sG", function() F.live_grep_resume({ winopts = M.winopts.lg.vertical }) end,  { desc = "Grep Resume"  })
M.bind("n", "sr", function() F.registers({ winopts = M.winopts.lg.vertical }) end,         { desc = "Registers"  })
M.bind("n", "sc", function() F.changes({ winopts = M.winopts.lg.vertical }) end,           { desc = "Buff changes"  })
M.bind("n", "s1", function() F.git_status({ winopts = M.winopts.lg.vertical }) end,        { desc = "Status"  })
M.bind("n", "s2", function() F.git_bcommits({ winopts = M.winopts.lg.vertical }) end,      { desc = "Bcommits"  })
M.bind("n", "s3", function() F.git_commits({ winopts = M.winopts.lg.vertical }) end,       { desc = "Commits"  })
M.bind("n", "sb", function() F.buffers({ winopts = M.winopts.sm.no_preview }) end,         { desc = "Buffers"  })

M.bind("n", "sv", function() F.files({ cwd = "~/.config/nvim" }) end, { desc = "VIMRC"  })
M.bind("n", "sn", function() F.files({ cwd = "~/vimwiki" }) end,      { desc = "NOTES"  })
M.bind("n", "sP", function() F.files({ cwd = "%:h" }) end,            { desc = "FILES Sibling" })

M.bind("n", "sp", F.files,   { desc = "FILES"  })
M.bind("n", "s0", F.resume,  { desc = "RESUME" } )
M.bind("n", "sq", F.builtin, { desc = "BUILTIN"  })
M.bind("n", "so", M.mru,     { desc = "OLDFILES" })

M.bind("i", "<c-k>", F.complete_path, { desc = "Fuzzy complete path" }) -- remap <C-X><C-F>
M.bind("i", "<c-l>", F.complete_line, { desc = "Fuzzy complete line" }) -- remap <C-X><C-L>

M.bind("n", "g<c-f>", function() F.files({ desc = "grep <word> (buffer)", prompt = "Files❯ ", query = vim.fn.expand("<cword>") }) end)

M.bind("n", "z=", function() F.spell_suggest({ winopts = M.winopts.sm.relative_cursor, }) end, { desc = "spell_suggest" })

M.lsp_attach = function()
  M.bind("n", "gd", function()
    F.lsp_definitions({
      jump_to_single_result = true,
      jump_type = "vsplit",
      winopts = M.winopts.lg.vertical,
    })
  end, { desc = "Go to [D]efinition" })

  M.bind("n", "gr", function()
    F.lsp_references({
      jump_to_single_result = true,
      jump_type = "vsplit",
      multiline = 2,

      winopts = M.winopts.lg.vertical,
    })
  end, { desc = "Go to [R]eferences" })

  M.bind("n", "<leader>la", function() F.lsp_code_actions() end, { desc = "[C]ode [A]ction" })
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

vim.api.nvim_create_user_command("F", function(info) F.files({ cwd = info.fargs[1] }) end, { nargs = "?", complete = "dir", desc = "Fuzzy find files.", })
-- stylua: ignore end
