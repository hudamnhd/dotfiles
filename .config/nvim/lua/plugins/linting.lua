return {
  "mfussenegger/nvim-lint",
  -- event = { "BufEnter", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

     lint.linters_by_ft = {
       javascript = { "eslint_d" }, -- https://eslint_d.dev/linter/rules/#recommended-rules
       typescript = { "eslint_d" },
       javascriptreact = { "eslint_d" },
       typescriptreact = { "eslint_d" },
       -- lua = { "luacheck" },
     }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

      local sign_defs = {
        {
          name = "DiagnosticSignError",
          text = "",
          -- text = '󰅚'
        },
        {
          name = "DiagnosticSignWarn",
          text = "",
          -- text = ''
        },
        {
          name = "DiagnosticSignInfo",
          text = "",
          -- text = '',
          -- text = '',
        },
        {
          name = "DiagnosticSignHint",
          text = "󰌵",
        },
      }

      local sign_opt -- changes depending on nvim version

        -- nvim 0.10.0 uses `nvim_buf_set_extmark`
        -- https://github.com/ibhagwan/fzf-lua/pull/1074
        -- vim.diagnostic.config({
        --   signs = {
        --     text = {
        --       [vim.diagnostic.severity.ERROR]  = "E",  -- index:0
        --       [vim.diagnostic.severity.WARN]   = "W",  -- index:1
        --       [vim.diagnostic.severity.INFO]   = "I",  -- index:2
        --       [vim.diagnostic.severity.HINT]   = "H",  -- index:3
        --     },
        --   },
        -- })
        sign_opt = { text = {} }
        for i, def in ipairs(sign_defs) do
          table.insert(sign_opt.text, def.text)
        end

      -- Diag config
      vim.diagnostic.config({
        float = { focus = false },
        underline = true,
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
  end,
}
