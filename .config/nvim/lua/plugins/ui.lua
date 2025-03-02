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
        -- for tokyonight
        highlights.LineNr = { fg = "#5D6293" }
        highlights.TabLine = { fg = c.comment, bg = c.bg_statusline }
        highlights.TabLineSel = { fg = c.bg, bg = c.blue }
        highlights.TabLineModifiedSel = { fg = c.bg, bg = c.warning }
        highlights.TabLineIndexSel = { fg = c.bg, bg = c.blue, bold = true }
        highlights.TabLineIndexModifiedSel = { fg = c.bg, bg = c.warning, bold = true }
        highlights.TabLineDivider = { fg = c.bg_statusline }
        highlights.TabLineDividerSel = { fg = c.blue, bg = c.blue }
        highlights.TabLineDividerVisible = { fg = c.blue }
        highlights.TabLineDividerModifiedSel = { fg = c.warning, bg = c.warning }

        -- palette = {
        --   bg             = "#222436", -- generate from 950
        --   bg_dark        = "#292C42", -- bg-900
        --   bg_dark1       = "#292C42", -- bg-900
        --   bg_highlight   = "#3B3F5E", -- bg-800
        --   blue           = "#82aaff",
        --   blue0          = "#3e68d7",
        --   blue1          = "#65bcff",
        --   blue2          = "#0db9d7",
        --   blue5          = "#89ddff",
        --   blue6          = "#b4f9f8",
        --   blue7          = "#394b70",
        --   comment        = "#7277A6", --bg-500
        --   cyan           = "#86e1fc",
        --   dark3          = "#545c7e",
        --   dark5          = "#7277A6", --bg-500
        --   fg             = "#c8d3f5",
        --   fg_dark        = "#7277A6", --bg-600
        --   fg_gutter      = "#7277A6", --bg-600
        --   green          = "#c3e88d",
        --   green1         = "#4fd6be",
        --   green2         = "#41a6b5",
        --   magenta        = "#c099ff",
        --   magenta2       = "#ff007c",
        --   orange         = "#ff966c",
        --   purple         = "#fca7ea",
        --   red            = "#ff757f",
        --   red1           = "#c53b53",
        --   teal           = "#4fd6be",
        --   terminal_black = "#7277A6", --bg-500
        --   yellow         = "#ffc777",
        --   git            = {
        --     add          = "#b8db87",
        --     change       = "#7ca1f2",
        --     delete       = "#e26a75",
        --   },
        -- }
      end,
    },
    config = true,
  },
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
          -- Override the builtin palette per variant
          -- stylua: ignore start
          moon = {
            _nc            = "#1f1d30",
            base           = "#232136",
            surface        = "#232136",
            overlay        = "#393552",
            muted          = "#908caa",
            subtle         = "#908caa",
            text           = "#e0def4",
            love           = "#eb6f92",
            gold           = "#f6c177",
            rose           = "#ea9a97",
            pine           = "#82aaff",
            foam           = "#9ccfd8",
            iris           = "#c4a7e7",
            leaf           = "#95b1ac",
            highlight_low  = "#2a283e",
            highlight_med  = "#44415a",
            highlight_high = "#56526e",
            none           = "NONE",
            -- stylua: ignore end
          },
        },

        -- NOTE: Highlight groups are extended (merged) by default. Disable this
        -- per group via `inherit = false`
        highlight_groups = {
          -- Comment = { fg = "foam" },
          -- StatusLine = { fg = "love", bg = "love", blend = 15 },
          -- VertSplit = { fg = "muted", bg = "muted" },
          -- Visual = { fg = "base", bg = "text", inherit = false },
        },

        before_highlight = function(group, highlight, palette)
          -- Disable all undercurls
          -- if highlight.undercurl then
          --     highlight.undercurl = false
          -- end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      })

      vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-dawn")
    end,
  },
  {
    "bluz71/nvim-linefly",
    lazy = true,
    enabled = true,
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
