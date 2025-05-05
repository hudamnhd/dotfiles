return {
    {
      "stevearc/oil.nvim",
      event = "VeryLazy",
      opts = {
        columns = {
          "size",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        experimental_watch_for_changes = true,
      },
      config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
      end,
    },
    {
      "ibhagwan/fzf-lua",
      enabled = vim.fn.executable("fzf") == 1,
      event = "VeryLazy",
      build = "fzf --version",
      config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
          { "border-fused", "hide" },

          hls = { border = "Normal" },
          fzf_colors = {
            true, -- inherit fzf colors that aren't specified below from
            ["fg"]      = { "fg", "Comment" },
            ["bg"]      = { "bg", "Normal" },
            ["hl"]      = { "fg", "Statement" },
            ["fg+"]     = { "fg", "Normal" },
            ["bg+"]     = { "bg", { "CursorLine", "Normal" } },
            ["hl+"]     = { "fg", "Statement" },
            ["info"]    = { "fg", "PreProc" },
            ["prompt"]  = { "fg", "Conditional" },
            ["pointer"] = { "fg", "Exception" },
            ["marker"]  = { "fg", "Keyword" },
            ["spinner"] = { "fg", "Label" },
            ["header"]  = { "fg", "Comment" },
            ["gutter"]  = "-1",
          },
        })

        fzf.register_ui_select(function(o, items)
          local min_h, max_h = 0.15, 0.70
          local preview = o.kind == "codeaction" and 0.20 or 0
          local h = (#items + 4) / vim.o.lines + preview
          if h < min_h then
            h = min_h
          elseif h > max_h then
            h = max_h
          end
          return { winopts = { height = h, width = 0.60, row = 0.40 } }
        end)

        -- stylua: ignore start
        vim.keymap.set("i", "<c-x><c-f>", fzf.complete_path, { desc = "Fzf 'complete_path'" }) -- remap
        vim.keymap.set("i", "<c-x><c-l>", fzf.complete_line, { desc = "Fzf 'complete_line'" }) -- remap
        vim.keymap.set("n", "<a-p>", fzf.builtin, { desc = "Fzf 'builtin'" })
        vim.keymap.set("n", "<c-b>", fzf.buffers, { desc = "Fzf 'buffers'" })
        vim.keymap.set("x", "sk", fzf.grep_visual, { desc = "Fzf 'grep_visual'" })
        vim.keymap.set("n", "sk", fzf.grep_cword, { desc = "Fzf 'grep_cword'" })
        vim.keymap.set("n", "sr", fzf.live_grep_resume, { desc = "Fzf 'live_grep_resume'" })
        vim.keymap.set("n", "si", fzf.grep, { desc = "Fzf 'grep'" })
        vim.keymap.set("n", "sl", fzf.lgrep_curbuf, { desc = "Fzf 'live_grep_buffer'" })
        vim.keymap.set("n", "ss", fzf.resume, { desc = "Fzf 'resume'" })
        vim.keymap.set("n", "s0", fzf.command_history, { desc = "Fzf 'command_history'" }) -- remap : to 0 easy press
        vim.keymap.set("n", "sp", fzf.files, { desc = "Fzf 'files'" })
        vim.keymap.set("n", "sh", fzf.search_history, { desc = "Fzf 'search_history'" })
        vim.keymap.set("n", "so", fzf.oldfiles, { desc = "Fzf 'oldfiles cwd'" })
        vim.keymap.set("n", "z=", fzf.spell_suggest, { desc = "Fzf 'spell_suggest'" })

        vim.api.nvim_create_user_command("F", function(info)
          fzf.files({ cwd = info.fargs[1] })
        end, {
          nargs = "?",
          complete = "dir",
          desc = "Fuzzy find files.",
        })

      end,
    },
    {
      'saghen/blink.cmp',
      event = "InsertEnter *",
      version = '1.*',
      dependencies = {
          "L3MON4D3/LuaSnip",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        keymap = { preset = 'super-tab' },

        appearance = {
          nerd_font_variant = 'mono'
        },

        completion = { documentation = { auto_show = false } },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      "tpope/vim-fugitive",
      dependencies = {
        {
          "junegunn/gv.vim",
          cmd = { "GV" },
        },
      },
      keys = {
        {
          "<C-G>",
          vim.cmd.Git,
          mode = { "n" },
          desc = "Git",
        },
      },
      config = function() end,
    }
}

