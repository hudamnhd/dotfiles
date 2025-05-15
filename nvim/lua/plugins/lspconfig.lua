return {
  {
    "neovim/nvim-lspconfig",
    ft = { "lua", "typescriptreact", "typescript" },
    config = function()
      vim.lsp.log.set_level(vim.log.levels.INFO)

      vim.lsp.config("lua_ls", {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (
                  vim.loop.fs_stat(path .. "/.luarc.json")
                  or vim.loop.fs_stat(path .. "/.luarc.jsonc")
                )
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.lsp.enable({
        "lua_ls",
      })
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
        -- Define how diagnostic entries should be shown
        signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
        underline = { severity = { min = 'HINT', max = 'ERROR' } },
        virtual_lines = false,
        virtual_text = { current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },

        -- Don't update diagnostics when typing
        update_in_insert = false,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      autostart = true,

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
