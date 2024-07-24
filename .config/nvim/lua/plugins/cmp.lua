return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "hrsh7th/cmp-buffer", -- source for text in buffer
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      cmp.setup({
        completion = {
          completeopt = "menu,menuone",
        },
        mapping = {
          ["<Tab>"] = {
            ["i"] = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              else
                fallback()
              end
            end,
          },
          ["<C-N>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ["<C-P>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },

        sources = cmp.config.sources({
          {
            name = "buffer",
            keyword_length = 3,
            max_item_count = 10,
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
    end,
  },
}
