return {
  {
    "yioneko/nvim-cmp",
    branch = "perf-up",
    event = "VeryLazy",
    dependencies = {
      "L3MON4D3/LuaSnip", -- for autocompletion
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "hrsh7th/cmp-buffer", -- source for text in buffer
    },
    config = function()
      local cmp = require("cmp")
      local utils = require("utils")
      local icons = utils.icons

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
              -- elseif require("luasnip").expand_or_jumpable() then
              --   vim.fn.feedkeys( vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
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
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, cmp_item)
            local compltype = vim.fn.getcmdcompltype()
            -- Use special icons for file / directory completions
            cmp_item.kind = icons.kinds[cmp_item.kind] or ""
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
    end,
  },
}
