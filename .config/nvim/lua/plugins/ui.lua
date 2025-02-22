return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        floats = "normal",
      },
      sidebars = { "qf", "help", "terminal" },
      on_highlights = function(highlights, c)
        for _, defn in pairs(highlights) do
          if defn.undercurl then
            defn.undercurl = false
            defn.underline = true
          end
        end
        highlights.LineNr = { fg = "#5D6293" }
        highlights.TabLineIndexSel = { fg = c.bg, bg = c.blue, bold = true }
      end,
    },
    config = true,
  },
  {
    "tomasiser/vim-code-dark",
    lazy = false,
    priority = 1000,
    config = function() end,
  },
  {
    "lunarvim/darkplus.nvim",
    lazy = false,
    priority = 1000,
    config = function() end,
  },
  {
    "bluz71/vim-nightfly-guicolors",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nightflyVirtualTextColor = true
      vim.g.nightflyItalics = false
      -- vim.cmd.colorscheme("nightfly")
    end,
  },
  {
    "bluz71/vim-moonfly-colors",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.moonflyVirtualTextColor = true
      vim.g.moonflyItalics = false
      vim.g.moonflyNormalFloat = true
      vim.cmd.colorscheme("moonfly")
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    config = function()
      local custom_latte = {
        rosewater = "#b75501",
        flamingo = "#b75501",
        pink = "#b75501",
        mauve = "#803378",
        red = "#c02d2e",
        maroon = "#b75501",
        peach = "#b75501",
        yellow = "#b75501",
        green = "#54790d",
        teal = "#54790d",
        sky = "#015692",
        sapphire = "#54790d",
        blue = "#015692",
        lavender = "#015692",
        text = "#2f3337",
        subtext1 = "#535a60",
        subtext0 = "#656e77",
        overlay2 = "#656e77",
        overlay1 = "#656e77",
        overlay0 = "#D1D1D1",
        surface0 = "#EBEBEB",
        surface1 = "#D1D1D1",
        surface2 = "#535a60",
        base = "#f6f6f6",
        mantle = "#f6f6f6",
        crust = "#f6f6f6",
      }
      require("catppuccin").setup({
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        no_bold = false,
        no_italic = true,
        color_overrides = {
          mocha = {
            base = "#131313",
            mantle = "#131313",
            crust = "#131313",
          },
          -- latte = custom_latte,
        },
        term_colors = false,
        highlight_overrides = {
          latte = function(cp)
            return {
              -- For base configs
              NormalFloat = { fg = cp.text, bg = cp.mantle },
              FloatBorder = {
                fg = cp.text,
                bg = cp.mantle,
              },
              LineNr = { link = "Comment" },
              CursorLineNr = { fg = cp.blue, style = { "bold" } },
              CursorLine = { bg = "#EBEBEB" },
              StatusLine = { bg = "#EBEBEB" },
              TabLine = { link = "Normal" },
              StatusLineNC = { link = "Normal" },
              MiniDiffSignAdd = { fg = cp.green, style = { "bold" } },
              MiniDiffSignDelete = { fg = cp.pink, style = { "bold" } },
              MiniDiffSignChange = { fg = cp.yellow, style = { "bold" } },
              ["FloatermBorder"] = { fg = cp.green },
              -- For native lsp configs
              DiagnosticVirtualTextError = { bg = cp.none },
              DiagnosticVirtualTextWarn = { bg = cp.none },
              DiagnosticVirtualTextInfo = { bg = cp.none },
              DiagnosticVirtualTextHint = { bg = cp.none },
              LspInfoBorder = { link = "FloatBorder" },

              -- For nvim-cmp and wilder.nvim
              Pmenu = { fg = cp.overlay2, bg = cp.none or cp.base },
              PmenuBorder = { fg = cp.surface1, bg = cp.none or cp.base },
              PmenuSel = { bg = cp.green, fg = cp.base },
              CmpItemAbbr = { fg = cp.overlay2 },
              CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
              CmpDoc = { link = "NormalFloat" },
              CmpDocBorder = {
                fg = cp.surface1 or cp.mantle,
                bg = cp.none or cp.mantle,
              },

              -- For treesitter
              ["@keyword.return"] = { fg = cp.pink },
              ["@error.c"] = { fg = cp.none },
              ["@error.cpp"] = { fg = cp.none },
            }
          end,
        },
      })
      -- pcall(vim.cmd, [[colorscheme catppuccin-mocha]])
      -- pcall(vim.cmd, [[hi! link LineNr NvimCallingParenthesis]])
    end,
  },
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
