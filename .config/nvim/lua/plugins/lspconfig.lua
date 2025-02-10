return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      -- "hrsh7th/cmp-nvim-lsp",
      -- "saghen/blink.cmp",
      {
        "lewis6991/hover.nvim",
        event = { "BufReadPost" },
        config = function()
          require("hover").setup({
            init = function()
              -- Require providers
              require("hover.providers.lsp")
              -- require('hover.providers.gh')
              -- require('hover.providers.gh_user')
              -- require('hover.providers.jira')
              -- require('hover.providers.dap')
              -- require('hover.providers.fold_preview')
              -- require('hover.providers.diagnostic')
              -- require('hover.providers.man')
              -- require('hover.providers.dictionary')
            end,
            preview_opts = {
              border = "single",
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
            mouse_providers = {
              "LSP",
            },
            mouse_delay = 1000,
          })
          -- Setup keymaps
          local bind = require("keymaps").bind
          bind("n", "K", require("hover").hover, { desc = "hover.nvim" })
          bind("n", "go", require("hover").hover_select, { desc = "hover.nvim (select)" })
          bind("n", "<a-[>", function()
            require("hover").hover_switch("previous")
          end, { desc = "hover.nvim (previous source)" })
          bind("n", "<a-]>", function()
            require("hover").hover_switch("next")
          end, { desc = "hover.nvim (next source)" })

          -- Mouse support
          bind("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
          vim.o.mousemoveevent = true
        end,
      },
    },
    config = function()
      -- local util = require("lspconfig.util")
      require("lspconfig").lua_ls.setup({})
      -- require("lspconfig").biome.setup({})
      -- require("lspconfig").dprint.setup({})
      -- require("lspconfig").denols.setup({})

      -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
      local sign_defs = {
        {
          name = "DiagnosticSignError",
          text = "", -- text = '󰅚'
        },
        {
          name = "DiagnosticSignWarn",
          text = "", -- text = ''
        },
        {
          name = "DiagnosticSignInfo",
          text = "", -- text = '', text = '',
        },
        {
          name = "DiagnosticSignHint",
          text = "󰌵",
        },
      }

      local sign_opt -- changes depending on nvim version

      sign_opt = { text = {} }
      for i, def in ipairs(sign_defs) do
        table.insert(sign_opt.text, def.text)
      end

      -- Diag config
      vim.diagnostic.config({
        float = { focus = false },
        -- underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "always",
          severity = {
            min = vim.diagnostic.severity.HINT,
          },
          -- format = function(diagnostic)
          -- if diagnostic.severity == vim.diagnostic.severity.ERROR then
          --   return string.format('E: %s', diagnostic.message)
          -- end
          -- return ("%s"):format(diagnostic.message)
          -- end,
        },
        signs = sign_opt,
        -- severity_sort = true,
        -- float = {
        --   show_header = false,
        --   source = "always",
        --   border = "rounded",
        -- },
      })

      return {
        toggle = function()
          if not vim.g.diag_is_hidden then
            require("utils.helper").info("Diagnostic virtual text is now hidden.")
            vim.diagnostic.hide()
          else
            require("utils.helper").info("Diagnostic virtual text is now visible.")
            vim.diagnostic.show()
          end
          vim.g.diag_is_hidden = not vim.g.diag_is_hidden
        end,
      }
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      root_dir = function(fname)
        local util = require("lspconfig.util")
        -- Disable tsserver on js files when a flow project is detected
        if not string.match(fname, ".tsx?$") and util.root_pattern(".flowconfig")(fname) then
          return nil
        end
        local ts_root = util.root_pattern("tsconfig.json")(fname)
          or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
        if ts_root then
          return ts_root
        end
        if vim.g.started_by_firenvim then
          return util.path.dirname(fname)
        end
        return nil
      end,
      settings = {
        separate_diagnostic_server = false,
        tsserver_max_memory = 4 * 1024,
        complete_function_calls = false,
        include_completions_with_insert_text = false,
      },
    },
    config = function(_, opts)
      local ts = require("typescript-tools")
      ts.setup(opts)
      -- Key mappings for typescript-tools.nvim
      local bind = require("keymaps").bind

      bind("n", "<space>lo", ":TSToolsOrganizeImports<CR>", { desc = "TSToolsOrganizeImports" })
      bind("n", "<space>ls", ":TSToolsSortImports<CR>", { desc = "TSToolsSortImports" })
      bind(
        "n",
        "<space>lr",
        ":TSToolsRemoveUnusedImports<CR>",
        { desc = "TSToolsRemoveUnusedImports" }
      )
      bind("n", "<space>lR", ":TSToolsRemoveUnused<CR>", { desc = "TSToolsRemoveUnused" })
      bind("n", "<space>lm", ":TSToolsAddMissingImports<CR>", { desc = "TSToolsAddMissingImports" })
      bind("n", "<space>lfa", ":TSToolsFixAll<CR>", { desc = "TSToolsFixAll" })
      bind(
        "n",
        "<space>ld",
        ":TSToolsGoToSourceDefinition<CR>",
        { desc = "TSToolsGoToSourceDefinition" }
      )
      bind("n", "<space>lfR", ":TSToolsRenameFile<CR>", { desc = "TSToolsRenameFile" })
      bind("n", "<space>lfr", ":TSToolsFileReferences<CR>", { desc = "TSToolsFileReferences" })
    end,
  },
}
