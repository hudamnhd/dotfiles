return {
  {
    "yioneko/nvim-cmp",
    branch = "perf-up",
    event = "VeryLazy",
    dependencies = {
      -- {
      --   "L3MON4D3/LuaSnip",
      --   build = (function()
      --     if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
      --       return
      --     end
      --     return "make install_jsregexp"
      --   end)(),
      --   dependencies = {
      --     {
      --       "rafamadriz/friendly-snippets",
      --       config = function()
      --         require("luasnip.loaders.from_vscode").lazy_load()
      --         local luasnip = require("luasnip")
      --         luasnip.setup()
      --
      --         luasnip.filetype_extend("lua", { "lua" })
      --         luasnip.filetype_extend("markdown", { "markdown" })
      --         luasnip.filetype_extend("javascriptreact", { "html" })
      --         luasnip.filetype_extend("php", { "html" })
      --         luasnip.filetype_extend("typescriptreact", { "html" })
      --       end,
      --     },
      --   },
      -- },
      -- "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      local icons = require("utils.static").icons
      local icon_dot = icons.DotLarge
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
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = {
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
          },
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
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
          { name = "nvim_lsp" },
          { name = "luasnip", max_item_count = 7, priority = 15 },
          {
            name = "buffer",
            keyword_length = 3,
            max_item_count = 5,
            priority = 1,
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
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, cmp_item)
            local compltype = vim.fn.getcmdcompltype()
            -- Use special icons for file / directory completions
            cmp_item.kind = entry.source.name == "cmdline" and icon_dot
              or icons.kinds[cmp_item.kind]
              or ""
            ---@param field string
            ---@param min_width integer
            ---@param max_width integer
            ---@return nil
            local function clamp(field, min_width, max_width)
              if not cmp_item[field] or not type(cmp_item) == "string" then
                return
              end
              -- In case that min_width > max_width
              if min_width > max_width then
                min_width, max_width = max_width, min_width
              end
              local field_str = cmp_item[field]
              local field_width = vim.fn.strdisplaywidth(field_str)
              if field_width > max_width then
                local former_width = math.floor(max_width * 0.6)
                local latter_width = math.max(0, max_width - former_width - 1)
                cmp_item[field] = string.format(
                  "%s…%s",
                  field_str:sub(1, former_width),
                  field_str:sub(-latter_width)
                )
              elseif field_width < min_width then
                cmp_item[field] = string.format("%-" .. min_width .. "s", field_str)
              end
            end
            clamp("abbr", vim.go.pw, math.max(60, math.ceil(vim.o.columns * 0.4)))
            clamp("menu", 0, math.max(16, math.ceil(vim.o.columns * 0.2)))
            return cmp_item
          end,
        },
        experimental = {
          native_menu = false,
          ghost_text = false,
        },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    end,
  },
}
