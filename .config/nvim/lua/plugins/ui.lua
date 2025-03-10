return {
  {
    "fenetikm/falcon",
    lazy = false,
    enabled = true,
    priority = 1000,
    config = function() end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {
      style = "moon",
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        floats = "normal",
      },
      sidebars = { "qf", "help", "terminal" },
      on_colors = function(colors)
        colors.bg = "#222436"
        colors.bg_float = "#222436"
        colors.bg_popup = "#222436"
        colors.bg_dark = "#292C42"
        colors.bg_dark1 = "#292C42"
        colors.bg_highlight = "#3B3F5E"
        colors.bg_visual = "#3B3F5E"
        colors.blue = "#82aaff"
        colors.blue0 = "#3e68d7"
        colors.blue1 = "#65bcff"
        colors.blue2 = "#0db9d7"
        colors.blue5 = "#89ddff"
        colors.blue6 = "#b4f9f8"
        colors.blue7 = "#394b70"
        colors.comment = "#7277A6"
        colors.cyan = "#86e1fc"
        colors.dark3 = "#545c7e"
        colors.dark5 = "#7277A6"
        colors.fg = "#c8d3f5"
        colors.fg_dark = "#7277A6"
        colors.fg_gutter = "#7277A6"
        colors.green = "#c3e88d"
        colors.green1 = "#4fd6be"
        colors.green2 = "#41a6b5"
        colors.magenta = "#c099ff"
        colors.magenta2 = "#ff007c"
        colors.orange = "#ff966c"
        colors.purple = "#fca7ea"
        colors.red = "#ff757f"
        colors.red1 = "#c53b53"
        colors.teal = "#4fd6be"
        colors.terminal_black = "#7277A6"
        colors.yellow = "#ffc777"
      end,
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
      end,
    },
    config = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    enabled = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("rose-pine").setup({
        -- variant = "main", -- auto, main, moon, or dawn
        -- dark_variant = "main", -- main, moon, or dawn
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
          hc = {
            _nc = "#292C42",
            base = "#222436",
            surface = "#222436",
            overlay = "#222436",
            muted = "#7277A6",
            subtle = "#7277A6",
            text = "#c8d3f5",
            love = "#ff757f",
            gold = "#ffc777",
            rose = "#ff966c",
            pine = "#82aaff",
            foam = "#4fd6be",
            iris = "#c099ff",
            leaf = "#c3e88d",
            highlight_low = "#21202e",
            highlight_med = "#403d52",
            highlight_high = "#524f67",
            none = "NONE",
          },
          moon = {
            pine = "#6CB0CB", -- "#82aaff" , "#0db9d7",
            muted = "#908caa",
          },
        },

        -- NOTE: Highlight groups are extended (merged) by default. Disable this
        -- per group via `inherit = false`
        highlight_groups = {
          -- Comment = { fg = "foam" },
          -- StatusLine = { fg = "love", bg = "love", blend = 15 },
          -- VertSplit = { fg = "muted", bg = "muted" },
          Visual = { bg = "#44415a", inherit = false },
        },
      })

      vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-dawn")
    end,
  },
  {
    "bluz71/nvim-linefly",
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
        with_search_count = true,
        with_spell_status = false,
        with_indent_status = true,
      }
    end,
  },
}
