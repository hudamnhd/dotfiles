--stylua: ignore start
-------------------------------------------------------------------------------
-- Options ====================================================================
-------------------------------------------------------------------------------
-- ( Leader Key )
vim.g.mapleader = vim.keycode('<space>')

-- ( General )
vim.o.backup      = false                -- Don't store backup
vim.o.mouse       = 'a'                  -- Enable mouse
vim.o.mousescroll = 'ver:25,hor:6'       -- Customize mouse scroll
vim.o.switchbuf   = 'usetab'             -- Use already opened buffers when switching
vim.o.writebackup = false                -- Don't store backup (better performance)
vim.o.undofile    = true                 -- Enable persistent undo
vim.o.undodir     = os.getenv('HOME') .. '/.vim/undodir'

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- ( UI )
vim.o.breakindent = true           -- Indent wrapped lines to match line start
vim.o.colorcolumn = '+1'           -- Draw colored column one step to the right of desired maximum width
vim.o.cursorline  = true           -- Enable highlighting of the current line
vim.o.linebreak   = true           -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list        = false          -- Show helpful character indicators
vim.o.number      = true           -- Show line numbers
vim.o.pumheight   = 10             -- Make popup menu smaller
vim.o.ruler       = false          -- Don't show cursor position
vim.o.shortmess   = 'FOSWaco'      -- Disable certain messages from |ins-completion-menu|
vim.o.showmode    = false          -- Don't show mode in command line
vim.o.signcolumn  = 'yes'          -- Always show signcolumn or it would frequently shift
vim.o.splitbelow  = true           -- Horizontal splits will be below
vim.o.splitright  = true           -- Vertical splits will be to the right
vim.o.wrap        = false          -- Display long lines as just one line

vim.o.fillchars   = table.concat(
  -- Special UI symbols
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)
vim.o.listchars            = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',') -- Special text symbols
vim.o.cursorlineopt        = 'screenline,number' -- Show cursor line only screen line when wrapped
vim.o.breakindentopt       = 'list:-1' -- Add padding for lists when 'wrap' is on

vim.o.pummaxwidth          = 100 -- Limit maximum width of popup menu
vim.o.completefuzzycollect = 'keyword,files,whole_line' -- Use fuzzy matching when collecting candidates

-- ( Colors )
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- ( Editing )
vim.o.autoindent    = true           -- Use auto indent
vim.o.expandtab     = true           -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j'       -- Improve comment editing
vim.o.ignorecase    = true           -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch     = true           -- Show search results while typing
vim.o.infercase     = true           -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth    = 2              -- Use this number of spaces for indentation
vim.o.smartcase     = true           -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent   = true           -- Make indenting smart
vim.o.tabstop       = 2              -- Insert 2 spaces for a tab
vim.o.virtualedit   = 'block'        -- Allow going past the end of line in visual block mode
vim.o.inccommand    = 'split'        -- Shows the effects of |:substitute|

vim.o.iskeyword     = '@,48-57,_,192-255,-' -- Treat dash separated words as a word text object

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat    = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.completeopt      = 'menuone,noselect' -- Show popup even with one item and don't autoselect first

-- ( Folds )
vim.o.foldmethod       = 'indent'  -- Set 'indent' folding method
vim.o.foldlevel        = 1         -- Display all folds except top ones
vim.o.foldnestmax      = 10        -- Create folds only for some number of nested levels
vim.g.markdown_folding = 1         -- Use folding by heading in markdown files

--stylua: ignore end
