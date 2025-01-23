return {
  {
    "https://github.com/lifepillar/vim-solarized8",
    lazy = false,
    branch = "neovim",
    priority = 1000,
    opts = {},
    config = function()
      -- require("jb").setup({transparent = true})
      -- vim.cmd("colorscheme jb")
    end,
  },
  {
    "nickkadutskyi/jb.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- require("jb").setup({transparent = true})
      -- vim.cmd("colorscheme jb")
    end,
  },
  -- Or with configuration
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("rose-pine").setup({
        variant = "moon", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },

        palette = {
          moon = {
            pine = "#a5b4fc",
          },
        },

        highlight_groups = {
          -- Comment = { fg = "foam" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },
      })

      -- vim.cmd("colorscheme rose-pine-moon")
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.g.catppuccin_flavour = "mocha"
      require("catppuccin").setup({
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        -- no_bold = false,
        no_italic = true,
        color_overrides = {
          mocha = {
            base = "#131313",
            mantle = "#131313",
            crust = "#131313",
          },
          latte = {
            base = "#F9F9FB",
            mantle = "#E8E8EC",
            crust = "#D9D9E0",
            rosewater = "#CA244D",
            flamingo = "#D13415",
            pink = "#C2298A",
            mauve = "#953EA3",
            red = "#CE2C31",
            maroon = "#CB1D63",
            peach = "#CC4E00",
            yellow = "#9E6C00",
            green = "#218358",
            teal = "#008573",
            sky = "#00749E",
            sapphire = "#0ea0a0",
            blue = "#0D74CE",
            lavender = "#3A5BC7",
            text = "#1C2024",
            subtext1 = "#60646C",
            subtext0 = "#80838D",
            overlay2 = "#777777",
            overlay1 = "#888888",
            overlay0 = "#999999",
            surface2 = "#aaaaaa",
            surface1 = "#bbbbbb",
            surface0 = "#cccccc",
          },
        },
        term_colors = true,
        highlight_overrides = {
          ---@param cp palette
          all = function(cp)
            return {
              -- For base configs
              -- NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
              -- FloatBorder = {
              --   fg = transparent_background and cp.blue or cp.mantle,
              --   bg = transparent_background and cp.none or cp.mantle,
              -- },
              TabLine = { link = "Normal" },
              StatusLineNC = { link = "Normal" },
              CursorLineNr = { fg = cp.green },
              MiniDiffSignAdd = { fg = cp.green, style = { "bold" } },
              MiniDiffSignDelete = { fg = cp.pink, style = { "bold" } },
              MiniDiffSignChange = { fg = cp.yellow, style = { "bold" } },
              CursorLineNr = { fg = cp.green },
              ["FloatermBorder"] = { fg = cp.green },
              -- For native lsp configs
              DiagnosticVirtualTextError = { bg = cp.none },
              DiagnosticVirtualTextWarn = { bg = cp.none },
              DiagnosticVirtualTextInfo = { bg = cp.none },
              DiagnosticVirtualTextHint = { bg = cp.none },
              LspInfoBorder = { link = "FloatBorder" },

              -- For nvim-cmp and wilder.nvim
              Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
              PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
              PmenuSel = { bg = cp.green, fg = cp.base },
              CmpItemAbbr = { fg = cp.overlay2 },
              CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
              CmpDoc = { link = "NormalFloat" },
              CmpDocBorder = {
                fg = transparent_background and cp.surface1 or cp.mantle,
                bg = transparent_background and cp.none or cp.mantle,
              },

              -- For treesitter
              ["@keyword.return"] = { fg = cp.pink, style = clear },
              ["@error.c"] = { fg = cp.none, style = clear },
              ["@error.cpp"] = { fg = cp.none, style = clear },
            }
          end,
        },
      })
      -- pcall(vim.cmd, [[colorscheme catppuccin-latte]])
      -- pcall(vim.cmd, [[hi! link LineNr NvimCallingParenthesis]])
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        -- ...
      })

      -- vim.cmd("colorscheme github_dark_colorblind")
      -- vim.cmd("colorscheme github_light")
    end,
  },
  -- {
  --   "olivercederborg/poimandres.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("poimandres").setup({
  --       -- leave this setup function empty for default config
  --       -- or refer to the configuration section
  --       -- for configuration options
  --     })
  --   end,
  --
  --   -- optionally set the colorscheme within lazy config
  --   init = function()
  --     vim.cmd("colorscheme poimandres")
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
