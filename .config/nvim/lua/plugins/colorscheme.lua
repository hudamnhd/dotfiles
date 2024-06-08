return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      groups = {
        all = {
          -- Make and/or/not stand out more
          ["@keyword.operator"] = { link = "@keyword" },
          -- Make markdown links stand out
          ["@text.reference"] = { link = "@keyword" },
          ["@text.emphasis"] = { style = "italic" },
          ["@text.strong"] = { style = "bold" },
          ["@text.literal"] = { style = "" }, -- Don't italicize
          ["@codeblock"] = { bg = "palette.bg0" },
          ["@neorg.markup.strikethrough"] = { fg = "palette.comment", style = "strikethrough" },
        },
      },
    },
    config = true,
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   enabled = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.g.catppuccin_flavour = "mocha"
  --     require("catppuccin").setup({
  --       compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  --       color_overrides = {
  --         mocha = {
  --           base = "#131313",
  --         },
  --       },
  --       term_colors = true,
  --       integrations = {
  --         treesitter = true,
  --       },
  --       custom_highlights = {
  --         NvimTreeNormal = { bg = "NONE" },
  --         CmpBorder = { fg = "#3e4145" },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   enabled = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({
  --       statementStyle = { bold = false },
  --       colors = {
  --         theme = {
  --           all = {
  --             ui = {
  --               bg_gutter = "none",
  --             },
  --           },
  --         },
  --         palette = {
  --           sumiInk0 = "#2A2A37",
  --         },
  --       },
  --       overrides = function(colors)
  --         local theme = colors.theme
  --         return {
  --
  --           -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
  --           -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
  --           -- PmenuSbar = { bg = theme.ui.bg_m1 },
  --           -- PmenuThumb = { bg = theme.ui.bg_p2 },
  --           -- NormalFloat = { bg = "none" },
  --           -- FloatBorder = { bg = "none" },
  --           -- FloatTitle = { bg = "none" },
  --           -- TabLine = { fg = theme.syn.fun, bg = theme.ui.shade0 },
  --           -- TabLineSel = { fg = theme.ui.shade0, bg = theme.ui.bg_p2, bold = true },
  --           -- TabLineModifiedSel = { fg = "#ff9e3b", bg = "none", bold = true },
  --           -- TabLineIndexSel = { fg = theme.ui.shade0, bg = theme.ui.bg_p2, bold = true },
  --           -- TabLineIndexModifiedSel = { fg = "#ff9e3b", bg = "none", bold = true },
  --           -- TabLineDivider = { fg = theme.syn.fun, bg = theme.ui.shade0 },
  --           -- TabLineDividerSel = { fg = theme.ui.shade0, bg = theme.ui.bg_p2 },
  --           -- TabLineDividerVisible = { fg = theme.syn.fun },
  --           -- TabLineDividerModifiedSel = { fg = "#ff9e3b", bg = "none" },
  --           -- Save an hlgroup with dark background and dimmed foreground
  --           -- so that you can use it where your still want darker windows.
  --           -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
  --           NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
  --
  --           -- Popular plugins that open floats will link to NormalFloat by default;
  --           -- set their background accordingly if you wish to keep them dark and borderless
  --           LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
  --           -- LineNr = { fg = colors.palette.boatYellow1 },
  --           Visual = { bg = colors.palette.waveBlue2 },
  --         }
  --       end,
  --     })
  --   end,
  -- },
  {
    "bluz71/nvim-linefly",
    lazy = false,
    config = function()
      vim.g.linefly_options = {
        separator_symbol = "◆",
        progress_symbol = "↓",
        active_tab_symbol = "▪",
        git_branch_symbol = "",
        error_symbol = "E",
        warning_symbol = "W",
        information_symbol = "I",
        ellipsis_symbol = "…",
        tabline = false,
        winbar = false,
        with_file_icon = true,
        with_git_branch = true,
        with_git_status = true,
        with_diagnostic_status = true,
        with_session_status = true,
        with_attached_clients = true,
        with_macro_status = false,
        with_search_count = false,
        with_spell_status = false,
        with_indent_status = false,
      }
    end,
  },
}
