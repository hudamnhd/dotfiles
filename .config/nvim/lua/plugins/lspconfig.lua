return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    -- dependencies = {
    --   -- main one
    --   { "ms-jpq/coq_nvim", branch = "coq" },
    --
    --   -- 9000+ Snippets
    --   { "ms-jpq/coq.artifacts", branch = "artifacts" },
    --
    --   -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
    --   -- Need to **configure separately**
    --   -- { "ms-jpq/coq.thirdparty", branch = "3p" },
    --   -- - shell repl
    --   -- - nvim lua api
    --   -- - scientific calculator
    --   -- - comment banner
    --   -- - etc
    -- },
    -- init = function()
    --   vim.g.coq_settings = {
    --     display = {
    --       statusline = { helo = false },
    --       pum = {
    --         fast_close = false,
    --         source_context = { "|", "|" },
    --       },
    --     },
    --     auto_start = true, -- if you want to start COQ at startup
    --     keymap = {
    --       recommended = false,
    --       jump_to_mark = "<a-tab>",
    --     },
    --     -- display = { icons = { mode = "none" } },
    --   }
    --
    --     -- stylua: ignore start
    --     vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap('i', '<BS>',  [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap("i", "<CR>",  [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? (complete_info().selected == -1 ? "\<C-N><C-Y>" : "\<C-y>") : "\<Tab>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap('i', '<C-N>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
    --     vim.api.nvim_set_keymap('i', '<C-P>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true })
    --   -- stylua: ignore end
    -- end,
    config = function()
      require("lspconfig").biome.setup({})
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
}
