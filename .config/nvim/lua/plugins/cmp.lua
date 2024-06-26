return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-path", -- source for file system paths
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-omni",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.setup()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      luasnip.filetype_extend("lua", { "lua" })
      luasnip.filetype_extend("markdown", { "markdown" })
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("php", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html" })

      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)

      cmp.setup({
        completion = {
          completeopt = "menu,menuone",
        },
        view = {
          docs = {
            auto_open = true,
          },
        },
        window = {
          documentation = {
            border = "rounded",
            max_height = 15,
            max_width = 50,
            zindex = 50,
          },
        },
        performance = {
          max_view_entries = 7,
        },
        -- completion = {
        --   completeopt = "menu,menuone,preview,noselect",
        -- },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = {
            -- ["c"] = function()
            --   if cmp.visible() then
            --     cmp.select_next_item()
            --   else
            --     cmp.complete()
            --   end
            -- end,
            ["i"] = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(
                  vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                  ""
                )
              else
                fallback()
              end
            end,
            ["c"] = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(
                  vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                  ""
                )
              else
                fallback()
              end
            end,
          },
          ["<S-Tab>"] = {
            ["c"] = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          },
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.confirm({ select = false, cmp.ConfirmBehavior.Insert })
              else
                cmp.close()
              end
            else
              fallback()
            end
          end),
        }, -- sources for autocompletion

        sources = cmp.config.sources({
          { name = "luasnip", keyword_length = 3, max_item_count = 5 },
          {
            name = "buffer",
            keyword_length = 4,
            options = {
              keyword_pattern = [[\k\+]],
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 250 * 1024 then -- 250kb
                  return {}
                end
                return { buf }
              end,
            },
          },
          { name = "path" }, -- file system paths
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        experimental = {
          native_menu = false,
          ghost_text = false,
        },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        sources = {
          {
            name = "buffer",
            keyword_length = 3,
            options = {
              keyword_pattern = [[\k\+]],
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 250 * 1024 then -- 250kb
                  return {}
                end
                return { buf }
              end,
            },
          },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 2 },
        }),
      })

      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources({ { name = "omni" } }),
      })
    end,
  },
}
