return {
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    -- branch = "perf-up",
    event = "VeryLazy",

    enabled = function()
      local disabled = false
      disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
      disabled = disabled or (vim.fn.reg_recording() ~= "")
      disabled = disabled or (vim.fn.reg_executing() ~= "")
      return not disabled
    end,
    dependencies = {
      "L3MON4D3/LuaSnip", -- for autocompletion
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      --* the sources *--
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
      "https://codeberg.org/FelipeLema/cmp-async-path", -- not by me, but better than cmp-path
    },
    config = function()
      local cmp = require("cmp")
      local utils = require("utils")
      local icons = utils.icons

      local compare = require("cmp.config.compare")
      local types = require("cmp.types")

      local WIDE_HEIGHT = 40

      preselect =
        types.cmp.PreselectMode.Item,
        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        cmp.setup({

          performance = {
            debounce = 60,
            throttle = 30,
            fetching_timeout = 500,
            filtering_context_budget = 3,
            confirm_resolve_timeout = 80,
            async_budget = 1,
            max_view_entries = 200,
          },
          completion = {
            autocomplete = {
              types.cmp.TriggerEvent.TextChanged,
            },
            completeopt = "menu,menuone,noselect",
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
            keyword_length = 1,
          },

          view = {
            entries = {
              name = "custom",
              selection_order = "top_down",
              vertical_positioning = "below",
              follow_cursor = false,
            },
            docs = {
              auto_open = true,
            },
          },

          window = {
            completion = {
              border = { "", "", "", "", "", "", "", "" },
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
              scrollbar_winhighlight = "EndOfBuffer:PmenuSbar,NormalFloat:PmenuSbar",
              scrollbar_thumb_winhighlight = "EndOfBuffer:PmenuThumb,NormalFloat:PmenuThumb",
              winblend = vim.o.pumblend,
              scrolloff = 0,
              col_offset = 0,
              side_padding = 1,
              scrollbar = true,
            },
            documentation = {
              max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
              max_width = math.floor(
                (WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))
              ),
              border = { "", "", "", " ", "", "", "", " " },
              winhighlight = "FloatBorder:NormalFloat",
              scrollbar_winhighlight = "EndOfBuffer:PmenuSbar,NormalFloat:PmenuSbar",
              scrollbar_thumb_winhighlight = "EndOfBuffer:PmenuThumb,NormalFloat:PmenuThumb",
              winblend = vim.o.pumblend,
              col_offset = 0,
            },
          },

          matching = {
            disallow_fuzzy_matching = false,
            disallow_fullfuzzy_matching = false,
            disallow_partial_fuzzy_matching = true,
            disallow_partial_matching = false,
            disallow_prefix_unmatching = false,
            disallow_symbol_nonprefix_matching = true,
          },

          sorting = {
            priority_weight = 2,
            comparators = {
              compare.offset,
              compare.exact,
              -- compare.scopes,
              compare.score,
              compare.recently_used,
              compare.locality,
              compare.kind,
              -- compare.sort_text,
              compare.length,
              compare.order,
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
            ["<C-y>"] = cmp.mapping.confirm({
              select = true,
              behavior = cmp.ConfirmBehavior.Replace,
            }),
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
                  local byte_size =
                    vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  if byte_size > 250 * 1024 then -- 250kb
                    return {}
                  end
                  return { buf }
                end,
              },
            },
            { name = "async_path" },
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
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "async_path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
