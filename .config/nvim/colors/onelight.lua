vim.cmd("hi clear")
if vim.g.syntax_on then
  vim.cmd("syn reset")
end
vim.o.background = "light"
vim.g.colors_name = "onelight"

-- stylua: ignore start
local red            = "#015692"
local dark_red       = "#015692"
local green          = "#54790d"
local yellow         = "#b75501"
local orange         = "#803378"
local blue           = "#b75501"
local purple         = "#2f3337"
local cyan           = "#2f3337"
local white          = "#2f3337"
local black          = "#F4F3F2"
local dim            = "#2f3337"
local light_grey     = "#4b5563"
local comment_grey   = "#656e77"
local gutter_fg_grey = "#656e77"
local cursor_grey    = "#d1d5db"
local float_grey     = "#F4F3F2"
local visual_grey    = "#c4c6cd"
local menu_grey      = "#FFFFFF"
local special_grey   = "#0f172a"
local vertsplit      = "#0f172a"
local diff_delete    = "#ffbcb5"
local diff_add       = "#aaedb7"
local diff_change    = "#9fd8ff"
local diff_text      = "#f4d88c"
local visual_black   = "NONE"

-- local red            = "#b91c1c"
-- local dark_red       = "#b91c1c"
-- local green          = "#166534"
-- local yellow         = "#854d0e"
-- local orange         = "#92400e"
-- local blue           = "#1e40af"
-- local purple         = "#6b21a8"
-- local cyan           = "#155e75"
-- local white          = "#14161b"
-- local black          = "#FFFFFF"
-- local dim            = "#1c1d23"
-- local light_grey     = "#4b5563"
-- local comment_grey   = "#6b7280"
-- local gutter_fg_grey = "#6b7280"
-- local cursor_grey    = "#d1d5db"
-- local float_grey     = "#FFFFFF"
-- local visual_grey    = "#c4c6cd"
-- local menu_grey      = "#FFFFFF"
-- local special_grey   = "#0f172a"
-- local vertsplit      = "#0f172a"
-- local diff_delete    = "#ffbcb5"
-- local diff_add       = "#aaedb7"
-- local diff_change    = "#9fd8ff"
-- local diff_text      = "#f4d88c"
-- local visual_black   = "NONE"
-- stylua: ignore end

local theme = {
  Comment = { fg = comment_grey, italic = true },
  Constant = { fg = cyan },
  String = { fg = green },
  Character = { fg = green },
  Number = { fg = orange },
  Boolean = { fg = orange },
  Float = { fg = orange },
  Identifier = { fg = red },
  Function = { fg = blue },
  Statement = { fg = purple },
  Conditional = { fg = purple },
  Repeat = { fg = purple },
  Label = { fg = purple },
  Operator = { fg = purple },
  Keyword = { fg = red },
  Exception = { fg = purple },
  PreProc = { fg = yellow },
  Include = { fg = blue },
  Define = { fg = purple },
  Macro = { fg = purple },
  PreCondit = { fg = yellow },
  Type = { fg = yellow },
  StorageClass = { fg = yellow },
  Structure = { fg = yellow },
  Typedef = { fg = yellow },
  Special = { fg = blue },
  SpecialChar = { fg = orange },
  Tag = {},
  Delimiter = {},
  SpecialComment = { fg = comment_grey },
  Debug = {},
  Underlined = { underline = true },
  Ignore = {},
  Error = { fg = red },
  Todo = { fg = purple },

  ColorColumn = { bg = cursor_grey },
  Conceal = {},
  Cursor = { bg = blue, fg = black },
  CursorIM = {},
  CursorColumn = { bg = cursor_grey },
  CursorLine = { bg = cursor_grey },
  Directory = { fg = blue },
  DiffAdd = { bg = diff_add },
  DiffDelete = { bg = diff_delete, fg = black },
  DiffChange = { bg = diff_change },
  DiffText = { bg = diff_text },
  ErrorMsg = { fg = red },
  VertSplit = { fg = vertsplit },
  Folded = { fg = comment_grey },
  FoldColumn = { fg = comment_grey },
  SignColumn = {},
  IncSearch = { bg = comment_grey, fg = yellow },
  LineNr = { fg = gutter_fg_grey },
  CursorLineNr = {},
  MatchParen = { fg = blue, underline = true },
  ModeMsg = {},
  MoreMsg = {},
  NonText = { fg = special_grey },
  Normal = { bg = black, fg = white },
  NormalFloat = { bg = float_grey, fg = white },
  Pmenu = { bg = menu_grey },
  PmenuSel = { bg = blue, fg = black },
  PmenuSbar = { bg = special_grey },
  PmenuThumb = { bg = white },
  Question = { fg = purple },
  QuickFixLine = { bg = blue, fg = black },
  Search = { bg = yellow, fg = black },
  SpecialKey = { fg = blue },
  SpecialKeyWin = { fg = special_grey },
  SpellBad = { fg = red, underline = true },
  SpellCap = { fg = orange },
  SpellLocal = { fg = orange },
  SpellRare = { fg = orange },
  StatusLine = { bg = cursor_grey, fg = white },
  StatusLineNC = { fg = comment_grey },
  StatusLineTerm = { bg = cursor_grey, fg = white },
  StatusLineTermNC = { fg = comment_grey },
  WinBar = { link = "StatusLine" },
  WinBarNC = { link = "StatusLineNC" },
  TabLine = { fg = comment_grey },
  TabLineFill = {},
  TabLineSel = { fg = white },
  Terminal = { bg = black, fg = white },
  Title = { fg = green },
  Visual = { bg = visual_grey, fg = visual_black },
  VisualNOS = { bg = visual_grey },
  WarningMsg = { fg = yellow },
  WildMenu = { bg = blue, fg = black },
  FloatBorder = { fg = comment_grey },
  -- MsgArea          = { bg = black, fg = white, blend = 20 },

  Dim = { bg = dim, fg = white },

  -- indent-blankline
  IndentBlanklineChar = { fg = gutter_fg_grey, nocombine = true },
  IndentBlanklineSpaceChar = { link = "IndentBlanklineChar" },
  IndentBlanklineSpaceCharBlankline = { link = "IndentBlanklineChar" },

  -- Neovim diagnostics
  DiagnosticError = { fg = orange },
  DiagnosticWarn = { fg = red },
  DiagnosticInfo = { fg = blue },
  DiagnosticHint = { fg = cyan },
  DiagnosticUnderlineError = { underline = true, fg = red },
  DiagnosticUnderlineWarn = { underline = true, fg = yellow },
  DiagnosticUnderlineInfo = { underline = true, fg = blue },
  DiagnosticUnderlineHint = { underline = true, fg = cyan },

  -- Neovim LSP
  LspReferenceText = { link = "Visual" },
  LspReferenceRead = { link = "Visual" },
  LspReferenceWrite = { link = "Visual" },

  -- Termdebug
  debugPC = { bg = special_grey },
  debugBreakpoint = { bg = red, fg = black },

  -- Lua
  luaFunction = { fg = blue },

  -- CSS
  cssAttrComma = { fg = purple },
  cssAttributeSelector = { fg = green },
  cssBraces = { fg = white },
  cssClassName = { fg = orange },
  cssClassNameDot = { fg = orange },
  cssDefinition = { fg = purple },
  cssFontAttr = { fg = orange },
  cssFontDescriptor = { fg = purple },
  cssFunctionName = { fg = blue },
  cssIdentifier = { fg = blue },
  cssImportant = { fg = purple },
  cssInclude = { fg = white },
  cssIncludeKeyword = { fg = purple },
  cssMediaType = { fg = orange },
  cssProp = { fg = white },
  cssPseudoClassId = { fg = orange },
  cssSelectorOp = { fg = purple },
  cssSelectorOp2 = { fg = purple },
  cssTagName = { fg = red },

  -- Fish Shell
  fishKeyword = { fg = purple },
  fishConditional = { fg = purple },

  -- Go
  goDeclaration = { fg = purple },
  goBuiltins = { fg = cyan },
  goFunctionCall = { fg = blue },
  goVarDefs = { fg = red },
  goVarAssign = { fg = red },
  goVar = { fg = purple },
  goConst = { fg = purple },
  goType = { fg = yellow },
  goTypeName = { fg = yellow },
  goDeclType = { fg = cyan },
  goTypeDecl = { fg = purple },

  -- HTML (keep consistent with Markdown, below)
  htmlArg = { fg = orange },
  htmlBold = { fg = orange, bold = true },
  htmlEndTag = { fg = white },
  htmlH1 = { fg = red },
  htmlH2 = { fg = red },
  htmlH3 = { fg = red },
  htmlH4 = { fg = red },
  htmlH5 = { fg = red },
  htmlH6 = { fg = red },
  htmlItalic = { fg = purple, italic = true },
  htmlLink = { fg = cyan, underline = true },
  htmlSpecialChar = { fg = orange },
  htmlSpecialTagName = { fg = red },
  htmlTag = { fg = white },
  htmlTagN = { fg = red },
  htmlTagName = { fg = red },
  htmlTitle = { fg = white },

  -- JavaScript
  javaScriptBraces = { fg = white },
  javaScriptFunction = { fg = purple },
  javaScriptIdentifier = { fg = purple },
  javaScriptNull = { fg = orange },
  javaScriptNumber = { fg = orange },
  javaScriptRequire = { fg = cyan },
  javaScriptReserved = { fg = purple },
  -- http//github.com/pangloss/vim-javascript
  jsArrowFunction = { fg = purple },
  jsClassKeyword = { fg = purple },
  jsClassMethodType = { fg = purple },
  jsDocParam = { fg = blue },
  jsDocTags = { fg = purple },
  jsExport = { fg = purple },
  jsExportDefault = { fg = purple },
  jsExtendsKeyword = { fg = purple },
  jsFrom = { fg = purple },
  jsFuncCall = { fg = blue },
  jsFunction = { fg = purple },
  jsGenerator = { fg = yellow },
  jsGlobalObjects = { fg = yellow },
  jsImport = { fg = purple },
  jsModuleAs = { fg = purple },
  jsModuleWords = { fg = purple },
  jsModules = { fg = purple },
  jsNull = { fg = orange },
  jsOperator = { fg = purple },
  jsStorageClass = { fg = purple },
  jsSuper = { fg = red },
  jsTemplateBraces = { fg = dark_red },
  jsTemplateVar = { fg = green },
  jsThis = { fg = red },
  jsUndefined = { fg = orange },
  -- http//github.com/othree/yajs.vim
  javascriptArrowFunc = { fg = purple },
  javascriptClassExtends = { fg = purple },
  javascriptClassKeyword = { fg = purple },
  javascriptDocNotation = { fg = purple },
  javascriptDocParamName = { fg = blue },
  javascriptDocTags = { fg = purple },
  javascriptEndColons = { fg = white },
  javascriptExport = { fg = purple },
  javascriptFuncArg = { fg = white },
  javascriptFuncKeyword = { fg = purple },
  javascriptIdentifier = { fg = red },
  javascriptImport = { fg = purple },
  javascriptMethodName = { fg = white },
  javascriptObjectLabel = { fg = white },
  javascriptOpSymbol = { fg = cyan },
  javascriptOpSymbols = { fg = cyan },
  javascriptPropertyName = { fg = green },
  javascriptTemplateSB = { fg = dark_red },
  javascriptVariable = { fg = purple },

  -- JSON
  jsonCommentError = { fg = white },
  jsonKeyword = { fg = red },
  jsonBoolean = { fg = orange },
  jsonNumber = { fg = orange },
  jsonQuote = { fg = white },
  jsonMissingCommaError = { fg = red, reverse = true },
  jsonNoQuotesError = { fg = red, reverse = true },
  jsonNumError = { fg = red, reverse = true },
  jsonString = { fg = green },
  jsonStringSQError = { fg = red, reverse = true },
  jsonSemicolonError = { fg = red, reverse = true },

  -- LESS
  lessVariable = { fg = purple },
  lessAmpersandChar = { fg = white },
  lessClass = { fg = orange },

  -- Markdown (keep consistent with HTML, above)
  markdownBlockquote = { fg = comment_grey },
  markdownBold = { fg = orange, bold = true },
  markdownCode = { fg = green },
  markdownCodeBlock = { fg = green },
  markdownCodeDelimiter = { fg = green },
  markdownH1 = { fg = red },
  markdownH2 = { fg = red },
  markdownH3 = { fg = red },
  markdownH4 = { fg = red },
  markdownH5 = { fg = red },
  markdownH6 = { fg = red },
  markdownHeadingDelimiter = { fg = red },
  markdownHeadingRule = { fg = comment_grey },
  markdownId = { fg = purple },
  markdownIdDeclaration = { fg = blue },
  markdownIdDelimiter = { fg = purple },
  markdownItalic = { fg = purple, italic = true },
  markdownLinkDelimiter = { fg = purple },
  markdownLinkText = { fg = blue },
  markdownListMarker = { fg = red },
  markdownOrderedListMarker = { fg = red },
  markdownRule = { fg = comment_grey },
  markdownUrl = { fg = cyan, underline = true },

  -- Perl
  perlFiledescRead = { fg = green },
  perlFunction = { fg = purple },
  perlMatchStartEnd = { fg = blue },
  perlMethod = { fg = purple },
  perlPOD = { fg = comment_grey },
  perlSharpBang = { fg = comment_grey },
  perlSpecialString = { fg = orange },
  perlStatementFiledesc = { fg = red },
  perlStatementFlow = { fg = red },
  perlStatementInclude = { fg = purple },
  perlStatementScalar = { fg = purple },
  perlStatementStorage = { fg = purple },
  perlSubName = { fg = yellow },
  perlVarPlain = { fg = blue },

  -- PHP
  phpVarSelector = { fg = red },
  phpOperator = { fg = white },
  phpParent = { fg = white },
  phpMemberSelector = { fg = white },
  phpType = { fg = purple },
  phpKeyword = { fg = purple },
  phpClass = { fg = yellow },
  phpUseClass = { fg = white },
  phpUseAlias = { fg = white },
  phpInclude = { fg = purple },
  phpClassExtends = { fg = green },
  phpDocTags = { fg = white },
  phpFunction = { fg = blue },
  phpFunctions = { fg = cyan },
  phpMethodsVar = { fg = orange },
  phpMagicConstants = { fg = orange },
  phpSuperglobals = { fg = red },
  phpConstants = { fg = orange },

  -- Ruby
  rubyBlockParameter = { fg = red },
  rubyBlockParameterList = { fg = red },
  rubyClass = { fg = purple },
  rubyConstant = { fg = yellow },
  rubyControl = { fg = purple },
  rubyEscape = { fg = red },
  rubyFunction = { fg = blue },
  rubyGlobalVariable = { fg = red },
  rubyInclude = { fg = blue },
  rubyIncluderubyGlobalVariable = { fg = red },
  rubyInstanceVariable = { fg = red },
  rubyInterpolation = { fg = cyan },
  rubyInterpolationDelimiter = { fg = red },
  rubyRegexp = { fg = cyan },
  rubyRegexpDelimiter = { fg = cyan },
  rubyStringDelimiter = { fg = green },
  rubySymbol = { fg = cyan },

  -- Sass
  -- http//github.com/tpope/vim-haml
  sassAmpersand = { fg = red },
  sassClass = { fg = orange },
  sassControl = { fg = purple },
  sassExtend = { fg = purple },
  sassFor = { fg = white },
  sassFunction = { fg = cyan },
  sassId = { fg = blue },
  sassInclude = { fg = purple },
  sassMedia = { fg = purple },
  sassMediaOperators = { fg = white },
  sassMixin = { fg = purple },
  sassMixinName = { fg = blue },
  sassMixing = { fg = purple },
  sassVariable = { fg = purple },
  -- http//github.com/cakebaker/scss-syntax.vim
  scssExtend = { fg = purple },
  scssImport = { fg = purple },
  scssInclude = { fg = purple },
  scssMixin = { fg = purple },
  scssSelectorName = { fg = orange },
  scssVariable = { fg = purple },

  -- TeX
  texStatement = { fg = purple },
  texSubscripts = { fg = orange },
  texSuperscripts = { fg = orange },
  texTodo = { fg = dark_red },
  texBeginEnd = { fg = purple },
  texBeginEndName = { fg = blue },
  texMathMatcher = { fg = blue },
  texMathDelim = { fg = blue },
  texDelimiter = { fg = orange },
  texSpecialChar = { fg = orange },
  texCite = { fg = blue },
  texRefZone = { fg = blue },

  -- TypeScript
  typescriptReserved = { fg = purple },
  typescriptEndColons = { fg = white },
  typescriptBraces = { fg = white },

  -- XML
  xmlAttrib = { fg = orange },
  xmlEndTag = { fg = red },
  xmlTag = { fg = red },
  xmlTagName = { fg = red },

  -- plasticboy/vim-markdown (keep consistent with Markdown, above)
  mkdDelimiter = { fg = purple },
  mkdHeading = { fg = red },
  mkdLink = { fg = blue },
  mkdURL = { fg = cyan, underline = true },

  -- tpope/vim-fugitive
  diffAdded = { fg = green },
  diffRemoved = { fg = red },
  diffChanged = { fg = yellow },

  -- lewis6991/gitsigns.nvim
  GitSignsAdd = { fg = green },
  GitSignsChange = { fg = yellow },
  GitSignsDelete = { fg = red },
  GitSignsCurrentLineBlame = { fg = comment_grey },

  -- Git Highlighting
  gitcommitComment = { fg = comment_grey },
  gitcommitUnmerged = { fg = green },
  gitcommitOnBranch = {},
  gitcommitBranch = { fg = purple },
  gitcommitDiscardedType = { fg = red },
  gitcommitSelectedType = { fg = green },
  gitcommitHeader = {},
  gitcommitUntrackedFile = { fg = cyan },
  gitcommitDiscardedFile = { fg = red },
  gitcommitSelectedFile = { fg = green },
  gitcommitUnmergedFile = { fg = yellow },
  gitcommitFile = {},
  gitcommitSummary = { fg = white },
  gitcommitOverflow = { fg = red },
  gitcommitNoBranch = { link = "gitcommitBranch" },
  gitcommitUntracked = { link = "gitcommitComment" },
  gitcommitDiscarded = { link = "gitcommitComment" },
  gitcommitSelected = { link = "gitcommitComment" },
  gitcommitDiscardedArrow = { link = "gitcommitDiscardedFile" },
  gitcommitSelectedArrow = { link = "gitcommitSelectedFile" },
  gitcommitUnmergedArrow = { link = "gitcommitUnmergedFile" },

  -- diffview
  DiffviewNormal = { link = "Dim" },
  DiffviewFilePanelTitle = { fg = blue },
  DiffviewFilePanelFileName = { fg = white },
  DiffviewNonText = { fg = comment_grey },

  -- lir
  LirDir = { fg = blue },
  LirSymLink = { fg = cyan },
  LirEmptyDirText = { fg = white },

  -- cheatsheet
  NvChAsciiHeader = { bg = black, fg = white }, -- Title
  NvChSection = { bg = black }, -- Each card

  NvCheatsheetWhite = { bg = white, fg = black },
  NvCheatsheetGray = { bg = gray, fg = white },
  NvCheatsheetBlue = { bg = blue, fg = black },
  NvCheatsheetCyan = { bg = cyan, fg = black },
  NvCheatsheetRed = { bg = red, fg = black },
  NvCheatsheetGreen = { bg = green, fg = black },
  NvCheatsheetYellow = { bg = yellow, fg = black },
  NvCheatsheetOrange = { bg = orange, fg = black },
  NvCheatsheetPurple = { bg = purple, fg = black },
  NvCheatsheetMagenta = { bg = magenta, fg = black },

  -- cmp
  CmpItemAbbr = { fg = white },
  CmpItemAbbrDeprecated = { fg = light_grey },
  CmpItemKind = { fg = blue },
  CmpItemMenu = { fg = comment_grey },

  neoreplOutput = { fg = green, bg = dim },
  neoreplValue = { fg = orange, bg = dim },
  neoreplError = { fg = red, bg = dim },
  neoreplInfo = { fg = blue, bg = dim },

  -- ['@keyword'] = { fg = purple },
  -- ['@variable'] = { fg = white },
  -- ['@property'] = { fg = white },
  -- ['@parameter'] = { fg = white },
}

-- Neovim diagnostics
if vim.env.TERM == "xterm-kitty" or vim.env.TERM == "alacritty" then
  theme.DiagnosticUnderlineError = { underline = true, special = red }
  theme.DiagnosticUnderlineWarn = { underline = true, special = yellow }
  theme.DiagnosticUnderlineInfo = { underline = true, special = blue }
  theme.DiagnosticUnderlineHint = { underline = true, special = cyan }
end

-- Neovim terminal colors
vim.g.terminal_color_0 = visual_grey
vim.g.terminal_color_1 = red
vim.g.terminal_color_2 = green
vim.g.terminal_color_3 = yellow
vim.g.terminal_color_4 = blue
vim.g.terminal_color_5 = purple
vim.g.terminal_color_6 = cyan
vim.g.terminal_color_7 = white
vim.g.terminal_color_8 = visual_grey
vim.g.terminal_color_9 = dark_red
vim.g.terminal_color_10 = green
vim.g.terminal_color_11 = orange
vim.g.terminal_color_12 = blue
vim.g.terminal_color_13 = purple
vim.g.terminal_color_14 = cyan
vim.g.terminal_color_15 = comment_grey
vim.g.terminal_color_background = black
vim.g.terminal_color_foreground = white

-- lightbulb
vim.fn.sign_define("LightBulbSign", { text = "?", texthl = "Number" })

vim.o.winhighlight = "SpecialKey:SpecialKeyWin"

local set_hl = vim.api.nvim_set_hl
for k, v in pairs(theme) do
  set_hl(0, k, v)
end

vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { bg = red, fg = black })
vim.api.nvim_set_hl(0, "MiniHipatternsHack", { bg = orange, fg = black })
vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { bg = green, fg = black })
vim.api.nvim_set_hl(0, "MiniHipatternsNote", { bg = blue, fg = black })
vim.api.nvim_set_hl(0, "LineflyNormal", { bg = red, fg = black })
vim.api.nvim_set_hl(0, "LineflyInsert", { bg = green, fg = black })
vim.api.nvim_set_hl(0, "LineflyVisual", { bg = orange, fg = black })
vim.api.nvim_set_hl(0, "LineflyReplace", { bg = yellow, fg = black })
vim.api.nvim_set_hl(0, "LineflyCommand", { bg = "#007373", fg = black })
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = green, bold = true }) -- Green for added lines
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = red, bold = true }) -- Yellow for changed lines
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = yellow, bold = true }) -- Red for deleted lines
