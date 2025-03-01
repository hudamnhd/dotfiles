return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
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

      vim.diagnostic.config({
        signs = sign_opt,
        virtual_text = true,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact" },
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
    end,
  },
}
