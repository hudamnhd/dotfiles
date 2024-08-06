return {
  {
    "yioneko/nvim-cmp",
    branch = "perf-up",
    event = "VeryLazy",
    dependencies = {
      {
        "hrsh7th/cmp-vsnip",
        dependencies = "hrsh7th/vim-vsnip",
        config = function()
          vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
          vim.g.vsnip_filetypes = {
            typescriptreact = { "javascript/react" },
            javascript = { "javascript/javascript" },
            typescript = { "javascript/typescript", "javascript/javascript" },
          }
        end,
      },
      "hrsh7th/cmp-buffer", -- source for text in buffer
    },
    config = function()
      local cmp = require("cmp")
      local icons = require("utils.icon")
      local icon_dot = icons.ui.DotLarge
      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      cmp.setup({
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
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
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = {
            ["i"] = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
              else
                fallback()
              end
            end,
          },
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
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
          { name = "vsnip", max_item_count = 5 },
          {
            name = "buffer",
            keyword_length = 3,
            options = {
              keyword_pattern = [[\k\+]],
            },
          },
        }),
        -- from https://github.com/Bekaboo/nvim/blob/master/lua/configs/nvim-cmp.lua
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
      })
    end,
  },
}
