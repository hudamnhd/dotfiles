local uv = vim.uv or vim.loop
local is_windows = uv.os_uname().version:match("Windows")
local sep = is_windows and "\\" or "/"

return {
  {
    "stevearc/three.nvim",
    -- commit = "713e20011f670e1209d51bdce46c740a774fa42c",
    event = "VeryLazy",
    opts = {
      bufferline = {
        events = { "BufReadPost", "BufWinLeave" },
        -- should_display = function(tabpage, bufnr, ts) return vim.bo[bufnr].modified end,
        enabled = true,
        icon = {
          -- Tab left/right dividers
          -- Set to this value for more a more compact look
          dividers = { "▍", "" },
          scroll = { "«", "»" },
          pin_divider = "",
          -- Pinned buffer icon
          pin = "󰐃",
        },
      },
      projects = {
        allowlist = {
          -- vim.fn.stdpath("data") .. "/lazy",
          -- vim.fs.normalize("~/vimwiki"),
        },
        extra_allowlist = {},
        filter_dir = function(dir)
          local dotgit = dir .. sep .. ".git"
          if vim.fn.isdirectory(dotgit) == 1 or vim.fn.filereadable(dotgit) == 1 then
            return true
          end
          -- If this is the child directory of a .git directory, ignore
          return vim.fn.finddir(".git", dir .. ";") == ""
        end,
      },
    },
    config = function(_, opts)
      -- vim.list_extend(opts.projects.allowlist, vim.tbl_keys(opts.projects.extra_allowlist))
      local three = require("three")
      three.setup(opts)
      -- stylua: ignore start
      --
        vim.keymap.set("n", "<C-T>",     three.prev,            { noremap = true, desc = "Previous buffer" })
        vim.keymap.set("n", "<C-Y>",     three.next,            { noremap = true, desc = "Next buffer" })
        vim.keymap.set("n", "<leader>`", three.wrap(three.next, { delta = 100 }), { desc = "Last buffer" })

        vim.keymap.set("n", "gt", three.wrap(three.next_tab, { wrap = true }), { desc = "Goto next Tab" })
        vim.keymap.set("n", "gT", three.wrap(three.prev_tab, { wrap = true }), { desc = "Goto prev Tab" })

      for i = 1, 9 do
        -- vim.keymap.set("n", i .. "b", three.wrap(three.jump_to, i))
        vim.keymap.set("n", "<a-".. i .. ">", three.wrap(three.jump_to, i), { desc = "Goto buffer " .. i })
      end

      for i = 1, 9 do
        vim.keymap.set("n", "<c-m-".. i .. ">", three.wrap(three.move_buffer, i))
      end

      vim.keymap.set("n", "<C-S-T>", vim.cmd.tabclose, { desc = "Close tab" })
      vim.keymap.set("n", "<C-S-P>", three.open_project, { desc = "Find Project" })
      vim.keymap.set("n", "<C-S-H>", three.hide_buffer, { desc = "Buffer Hide" })
      vim.keymap.set("n", "<C-S-B>", three.clone_tab,     { desc = "Clone tab" })
      vim.keymap.set("n", "<C-S-N>", "<cmd>tabnew | set nobuflisted<CR>", { desc = "New tab" })

        local function buff_del_all()
            local current_bufnr = vim.api.nvim_get_current_buf()
            local current_tabpage = vim.api.nvim_get_current_tabpage()
            local visible_buffers = {}
            local ts = three.get_tab_state(current_tabpage)
            for _, bufnr in ipairs(ts.buffers) do
              if bufnr ~= current_bufnr then
                  visible_buffers[bufnr] = true
              end
            end

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if (vim.bo[bufnr].buflisted) and visible_buffers[bufnr] then
                    three.close_buffer(bufnr)
                end
            end
        end

      vim.keymap.set("n", "<leader>q", three.smart_close, { desc = "delete buff current" })
      vim.keymap.set("n", "<leader>x", buff_del_all,      { desc = "delete all buff not current" })

      vim.api.nvim_create_user_command("ProjectDelete", function() three.remove_project() end, {})

      vim.api.nvim_create_user_command("ProjectAdd", function()
        local cwd = vim.loop.cwd()
        local project_path = vim.fn.fnamemodify(path, ":p:h")
        three.add_project(project_path)
        print("Adding project at path: " .. project_path)
      end, {})

      vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#343D46", bg = "#D8DEE9" })
      vim.api.nvim_set_hl(0, "TabLineDividerSel", { fg = "#343D46", bg = "#D8DEE9" })
      vim.api.nvim_set_hl(0, "TabLineIndexSel", { fg = "#343D46", bg = "#D8DEE9" })
      vim.api.nvim_set_hl(0, "TabLine", { fg = "#eeeeee", bg = "#3d4751" })
      vim.api.nvim_set_hl(0, "TabLineDir", { fg = "#D8DEE9", bg = "#343D46" })
      vim.api.nvim_set_hl(0, "TabLineDivider", { fg = "#eeeeee", bg = "#3d4751" })
      vim.api.nvim_set_hl(0, "TabLineDividerVisible", { fg = "#eeeeee", bg = "#3d4751" })
      vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#D8DEE9", bg = "#343D46" })
      vim.api.nvim_set_hl(0, "TabLineIndex", { fg = "#eeeeee", bg = "#3d4751" })
      vim.api.nvim_set_hl(0, "TabLineIndexVisible", { fg = "#343D46", bg = "#D8DEE9" })
      vim.api.nvim_set_hl(0, "TabLineScrollIndicator", { fg = "#eeeeee", bg = "#3d4751" })
      vim.api.nvim_set_hl(0, "TabLineVisible", { fg = "#343D46", bg = "#D8DEE9" })
      vim.api.nvim_set_hl(0, "TabLineModified", { bg = "#343D46", fg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineModifiedVisible", { bg = "#343D46", fg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineIndexModified", { bg = "#343D46", fg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineIndexModifiedVisible", { bg = "#343D46", fg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineDividerModified", { bg = "#343D46", fg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineDividerModifiedVisible", { fg = "#343D46", bg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineModifiedSel", { fg = "#343D46", bg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineIndexModifiedSel", { fg = "#343D46", bg = "#F9AE58" })
      vim.api.nvim_set_hl(0, "TabLineDividerModifiedSel", { fg = "#343D46", bg = "#F9AE58" })
      -- stylua: ignore end
    end,
  },
}
