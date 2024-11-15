return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.g.catppuccin_flavour = "mocha"
  --     require("catppuccin").setup({
  --       compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  --       -- no_bold = false,
  --       no_italic = true,
  --       color_overrides = {
  --         mocha = {
  --           base = "#131313",
  --           mantle = "#131313",
  --           crust = "#131313",
  --         },
  --       },
  --       term_colors = true,
  --       highlight_overrides = {
  --         ---@param cp palette
  --         all = function(cp)
  --           return {
  --             -- For base configs
  --             -- NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
  --             -- FloatBorder = {
  --             --   fg = transparent_background and cp.blue or cp.mantle,
  --             --   bg = transparent_background and cp.none or cp.mantle,
  --             -- },
  --             TabLine = { link = "Normal" },
  --             StatusLineNC = { link = "Normal" },
  --             CursorLineNr = { fg = cp.green },
  --             MiniDiffSignAdd = { fg = cp.green, style = { "bold" } },
  --             MiniDiffSignDelete = { fg = cp.pink, style = { "bold" } },
  --             MiniDiffSignChange = { fg = cp.yellow, style = { "bold" } },
  --             CursorLineNr = { fg = cp.green },
  --             ["FloatermBorder"] = { fg = cp.green },
  --             -- For native lsp configs
  --             DiagnosticVirtualTextError = { bg = cp.none },
  --             DiagnosticVirtualTextWarn = { bg = cp.none },
  --             DiagnosticVirtualTextInfo = { bg = cp.none },
  --             DiagnosticVirtualTextHint = { bg = cp.none },
  --             LspInfoBorder = { link = "FloatBorder" },
  --
  --             -- For nvim-cmp and wilder.nvim
  --             Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
  --             PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
  --             PmenuSel = { bg = cp.green, fg = cp.base },
  --             CmpItemAbbr = { fg = cp.overlay2 },
  --             CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
  --             CmpDoc = { link = "NormalFloat" },
  --             CmpDocBorder = {
  --               fg = transparent_background and cp.surface1 or cp.mantle,
  --               bg = transparent_background and cp.none or cp.mantle,
  --             },
  --
  --             -- For treesitter
  --             ["@keyword.return"] = { fg = cp.pink, style = clear },
  --             ["@error.c"] = { fg = cp.none, style = clear },
  --             ["@error.cpp"] = { fg = cp.none, style = clear },
  --           }
  --         end,
  --       },
  --     })
  --     pcall(vim.cmd, [[colorscheme catppuccin]])
  --     pcall(vim.cmd, [[hi! link LineNr NvimCallingParenthesis]])
  --   end,
  -- },
  {
    "bluz71/nvim-linefly",
    lazy = true,
    event = "VimEnter",
    config = function()
      vim.g.linefly_options = {
        separator_symbol = "◆",
        progress_symbol = "↓",
        active_tab_symbol = "▪",
        git_branch_symbol = "",
        error_symbol = "",
        warning_symbol = "",
        information_symbol = "",
        ellipsis_symbol = "…",
        tabline = false,
        winbar = false,
        with_file_icon = true,
        with_git_branch = true,
        with_git_status = true,
        with_diagnostic_status = true,
        with_session_status = true,
        with_attached_clients = true,
        with_macro_status = true,
        with_search_count = false,
        with_spell_status = false,
        with_indent_status = true,
      }
    end,
  },
}
