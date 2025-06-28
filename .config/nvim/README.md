# 🚀 Neovim Configuration

The main goals of the minimalist Neovim setup were:
- **Single-file editing**
- Based on [mini.nvim](https://github.com/echasnovski/mini.nvim)
- Clear, readable keymaps

## ✨ Highlights

-  Plugins, primarily from `mini.nvim`.
- 🔥 Qualities:
  - `ibhagwan/fzf-lua` Fuzzy finder
  - `rose-pine/neovim` Color scheme
  - `tpope/vim-fugitive` Git integration
  - `saghen/blink.cmp` Auto completion
  - `neovim/nvim-lspconfig` Configs for lsp
  - `nvim-treesitter/nvim-treesitter` Syntax parsing, highlighting and textobjects
  - `nvim-treesitter/nvim-treesitter-textobjects` Syntax aware text-objects
- 🗂 [mini.nvim](https://github.com/echasnovski/mini.nvim) modules:
  - `mini.ai` Extend and create `a`/`i` textobjects
  - `mini.align` Align text interactively
  - `mini.comment` Comment lines
  - `mini.keymap` Special key mappings
  - `mini.move` Move any selection in any direction
  - `mini.operators` Text edit operators
  - `mini.pairs` Autopairs
  - `mini.splitjoin` Split and join arguments
  - `mini.surround` Surround actions
  - `mini.bracketed` Go forward/backward with square brackets
  - `mini.bufremove` Remove buffers
  - `mini.clue` Show next key clues
  - `mini.deps` Plugin manager
  - `mini.diff` Work with diff hunks
  - `mini.extra` Extra 'mini.nvim' functionality
  - `mini.files` Navigate and manipulate file system
  - `mini.jump` Jump to next/previous single character
  - `mini.jump2d` Jump within visible lines
  - `mini.misc` Miscellaneous functions
  - `mini.sessions` Session management
  - `mini.colors` Tweak and save any color scheme
  - `mini.hipatterns` Highlight patterns in text
  - `mini.icons` Icon provider
  - `mini.indentscope` Visualize and work with indent scope
  - `mini.notify` Show notifications
  - `mini.starter` Start screen
  - `mini.statusline` Statusline
  - `mini.tabline` Tabline
  - `mini.trailspace` Trailspace (highlight and remove)

## 🎯 Keymaps

The central `actions` table facilitates the reading of mappings:

```lua
local actions = {
    match_bracket = '%',
    goto_line_start = '^',
    goto_line_end = 'g_',
  }
```

* Used like:

```lua
{ '<C-z>', actions.match_bracket, { mode = 'nv' } }
```
