return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
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
