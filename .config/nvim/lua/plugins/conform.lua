return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        -- stylua: ignore start
        javascript      = { "deno_fmt" },
        typescript      = { "deno_fmt" },
        javascriptreact = { "deno_fmt" },
        typescriptreact = { "deno_fmt" },
        svelte          = { "deno_fmt" },
        css             = { "deno_fmt" },
        html            = { "deno_fmt" },
        json            = { "deno_fmt" },
        markdown        = { "deno_fmt" },
        lua             = { "stylua" },
        -- stylua: ignore end
      },
    })

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })
  end,
}
