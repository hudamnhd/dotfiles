-- stylua: ignore start
vim.cmd('hi clear')
if vim.g.syntax_on then
  vim.cmd('syn reset')
end
vim.o.background = 'dark'
vim.g.colors_name = 'onedark'
-- +---------------------------------------------+
-- | Color Name   | RGB                | Hex     |
-- | --------------+--------------------+---------|
-- | Black        | rgb(40, 44, 52)    | #282c34 |
-- | --------------+--------------------+---------|
-- | White        | rgb(171, 178, 191) | #abb2bf |
-- | --------------+--------------------+---------|
-- | Light Red    | rgb(224, 108, 117) | #e06c75 |
-- | --------------+--------------------+---------|
-- | Dark Red     | rgb(190, 80, 70)   | #be5046 |
-- | --------------+--------------------+---------|
-- | Green        | rgb(152, 195, 121) | #98c379 |
-- | --------------+--------------------+---------|
-- | Light Yellow | rgb(229, 192, 123) | #e5c07b |
-- | --------------+--------------------+---------|
-- | Dark Yellow  | rgb(209, 154, 102) | #d19a66 |
-- | --------------+--------------------+---------|
-- | Blue         | rgb(97, 175, 239)  | #61afef |
-- | --------------+--------------------+---------|
-- | Magenta      | rgb(198, 120, 221) | #c678dd |
-- | --------------+--------------------+---------|
-- | Cyan         | rgb(86, 182, 194)  | #56b6c2 |
-- | --------------+--------------------+---------|
-- | Gutter Grey  | rgb(76, 82, 99)    | #4b5263 |
-- | --------------+--------------------+---------|
-- | Comment Grey | rgb(92, 99, 112)   | #5c6370 |
-- | --------------+--------------------+---------|
-- | Cursor Grey  | rgb(76, 82, 99)    | #31363F |
-- | --------------+--------------------+---------|
-- | Visual Grey  | rgb(92, 99, 112)   | #434956 |
-- +---------------------------------------------+

local function adjust_brightness(color, amount)
  local r, g, b = tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6, 7), 16)
  r = math.max(0, math.min(255, r + amount))
  g = math.max(0, math.min(255, g + amount))
  b = math.max(0, math.min(255, b + amount))
  return string.format("#%02X%02X%02X", r, g, b)
end

local colors = {
  red            = "#e06c75",
  dark_red       = "#BE5046",
  green          = "#98c379",
  yellow         = "#e5c07b",
  orange         = "#d19a66",
  blue           = "#61afef",
  purple         = "#c678dd",
  cyan           = "#56b6c2",
  white          = "#abb2bf",
  black          = "#282c34",
  dim            = "#282c34",
  visual_black   = 'NONE',
  light_grey     = "#5c6370",
  comment_grey   = "#7f848e",
  gutter_fg_grey = "#546175",
  cursor_grey    = "#31363F",
  float_grey     = "#282c34", --bg-floating
  visual_grey    = "#434956",
  menu_grey      = "#353b45",
  special_grey   = "#4b5263",
  vertsplit      = "#282c34",
  diff_delete    = "#4C343B",
  diff_add       = "#3E4C3E",
  diff_change    = "#2F3135",
  diff_text      = "#3E4C3E"
}

local themes = {
  normal = function()
    return {
      red      = colors.red,
      dark_red = colors.dark_red,
      green    = colors.green,
      yellow   = colors.yellow,
      orange   = colors.orange,
      blue     = colors.blue,
      purple   = colors.purple,
      cyan     = colors.cyan,
      black    = colors.black,
      white    = colors.white,
    }
  end,

  soft = function()
    return {
      red      = adjust_brightness(colors.red,      20),
      dark_red = adjust_brightness(colors.dark_red, 20),
      green    = adjust_brightness(colors.green,    20),
      yellow   = adjust_brightness(colors.yellow,   20),
      orange   = adjust_brightness(colors.orange,   20),
      blue     = adjust_brightness(colors.blue,     20),
      purple   = adjust_brightness(colors.purple,   20),
      cyan     = adjust_brightness(colors.cyan,     20),
      black    = adjust_brightness(colors.black,    20),
      white    = adjust_brightness(colors.white,    20),
    }
  end,

  dark = function()
    return {
      red      = adjust_brightness(colors.red     , -5),
      dark_red = adjust_brightness(colors.dark_red, -5),
      green    = adjust_brightness(colors.green   , -5),
      yellow   = adjust_brightness(colors.yellow  , -5),
      orange   = adjust_brightness(colors.orange  , -5),
      blue     = adjust_brightness(colors.blue    , -5),
      purple   = adjust_brightness(colors.purple  , -5),
      cyan     = adjust_brightness(colors.cyan    , -5),
      black    = adjust_brightness(colors.black,    -5),
      white    = adjust_brightness(colors.white,    -5),
    }
  end,

  warm = function()
    return {
      red      = adjust_brightness(colors.red     , 10),
      dark_red = adjust_brightness(colors.dark_red, 10),
      green    = adjust_brightness(colors.green   , 10),
      yellow   = adjust_brightness(colors.yellow  , 10),
      orange   = adjust_brightness(colors.orange  , 10),
      blue     = adjust_brightness(colors.blue    , 10),
      purple   = adjust_brightness(colors.purple  , 10),
      cyan     = adjust_brightness(colors.cyan    , 10),
      black    = adjust_brightness(colors.black,    10),
      white    = adjust_brightness(colors.white,    10),
    }
  end,
}

local active_theme = themes.normal()

local red            = active_theme.red
local dark_red       = active_theme.dark_red
local green          = active_theme.green
local yellow         = active_theme.yellow
local orange         = active_theme.orange
local blue           = active_theme.blue
local purple         = active_theme.purple
local cyan           = active_theme.cyan
local white          = active_theme.white
local black          = active_theme.black
local dim            = active_theme.black
local visual_black   = "NONE"
local light_grey     = colors.light_grey
local comment_grey   = colors.comment_grey
local gutter_fg_grey = colors.gutter_fg_grey
local cursor_grey    = colors.cursor_grey
local float_grey     = active_theme.black     --bg-floating
local visual_grey    = colors.visual_grey
local menu_grey      = colors.menu_grey
local special_grey   = colors.special_grey
local vertsplit      = colors.vertsplit
local diff_delete    = colors.diff_delete
local diff_add       = colors.diff_add
local diff_change    = colors.diff_change
local diff_text      = colors.diff_text

local theme = {
  Comment        = { fg = comment_grey, italic = true },
  Constant       = { fg = cyan },
  String         = { fg = green },
  Character      = { fg = green },
  Number         = { fg = orange },
  Boolean        = { fg = orange },
  Float          = { fg = orange },
  Identifier     = { fg = red },
  Function       = { fg = blue },
  Statement      = { fg = purple },
  Conditional    = { fg = purple },
  Repeat         = { fg = purple },
  Label          = { fg = purple },
  Operator       = { fg = purple },
  Keyword        = { fg = red },
  Exception      = { fg = purple },
  PreProc        = { fg = yellow },
  Include        = { fg = blue },
  Define         = { fg = purple },
  Macro          = { fg = purple },
  PreCondit      = { fg = yellow },
  Type           = { fg = yellow },
  StorageClass   = { fg = yellow },
  Structure      = { fg = yellow },
  Typedef        = { fg = yellow },
  Special        = { fg = blue },
  SpecialChar    = { fg = orange },
  Tag            = { },
  Delimiter      = { },
  SpecialComment = { fg = comment_grey },
  Debug          = { },
  Underlined     = { underline = true },
  Ignore         = { },
  Error          = { fg = red },
  Todo           = { fg = purple },

  ColorColumn      = { bg = cursor_grey },
  Conceal          = { },
  Cursor           = { bg = blue, fg = black },
  CursorIM         = { },
  CursorColumn     = { bg = cursor_grey },
  CursorLine       = { bg = cursor_grey },
  Directory        = { fg = blue },
  DiffAdd          = { bg = diff_add },
  DiffDelete       = { bg = diff_delete, fg = black },
  DiffChange       = { bg = diff_change },
  DiffText         = { bg = diff_text },
  ErrorMsg         = { fg = red },
  VertSplit        = { fg = vertsplit },
  Folded           = { fg = comment_grey },
  FoldColumn       = { fg = comment_grey },
  SignColumn       = { },
  IncSearch        = { bg = comment_grey, fg = yellow },
  LineNr           = { fg = gutter_fg_grey },
  CursorLineNr     = { },
  MatchParen       = { fg = blue, underline = true },
  ModeMsg          = { },
  MoreMsg          = { },
  NonText          = { fg = special_grey },
  Normal           = { bg = black, fg = white },
  NormalFloat      = { bg = float_grey, fg = white },
  Pmenu            = { bg = menu_grey },
  PmenuSel         = { bg = blue, fg = black },
  PmenuSbar        = { bg = special_grey },
  PmenuThumb       = { bg = white },
  Question         = { fg = purple },
  QuickFixLine     = { bg = blue, fg = black },
  Search           = { bg = yellow, fg = black },
  SpecialKey       = { fg = blue },
  SpecialKeyWin    = { fg = special_grey },
  SpellBad         = { fg = red, underline = true },
  SpellCap         = { fg = orange },
  SpellLocal       = { fg = orange },
  SpellRare        = { fg = orange },
  StatusLine       = { bg = cursor_grey, fg = white },
  StatusLineNC     = { fg = comment_grey },
  StatusLineTerm   = { bg = cursor_grey, fg = white },
  StatusLineTermNC = { fg = comment_grey },
  WinBar           = { link = 'StatusLine' },
  WinBarNC         = { link = 'StatusLineNC' },
  TabLine          = { fg = comment_grey },
  TabLineFill      = { },
  TabLineSel       = { fg = white },
  Terminal         = { bg = black, fg = white },
  Title            = { fg = green },
  Visual           = { bg = visual_grey, fg = visual_black },
  VisualNOS        = { bg = visual_grey },
  WarningMsg       = { fg = yellow },
  WildMenu         = { bg = blue, fg = black },
  FloatBorder      = { fg = comment_grey },
  -- MsgArea          = { bg = black, fg = white, blend = 20 },

  Dim = { bg = dim, fg = white },

  -- indent-blankline
  IndentBlanklineChar               = { fg = gutter_fg_grey, nocombine = true },
  IndentBlanklineSpaceChar          = { link = 'IndentBlanklineChar' },
  IndentBlanklineSpaceCharBlankline = { link = 'IndentBlanklineChar' },

  -- Neovim diagnostics
  DiagnosticError          = { fg = red },
  DiagnosticWarn           = { fg = yellow },
  DiagnosticInfo           = { fg = blue },
  DiagnosticHint           = { fg = cyan },
  DiagnosticUnderlineError = { underline = true, fg = red },
  DiagnosticUnderlineWarn  = { underline = true, fg = yellow },
  DiagnosticUnderlineInfo  = { underline = true, fg = blue },
  DiagnosticUnderlineHint  = { underline = true, fg = cyan },

  -- Neovim LSP
  LspReferenceText  = { link = 'Visual' },
  LspReferenceRead  = { link = 'Visual' },
  LspReferenceWrite = { link = 'Visual' },

  -- Termdebug
  debugPC          = { bg = special_grey },
  debugBreakpoint  = { bg = red, fg = black },

  -- Lua
  luaFunction = { fg = blue },

  -- CSS
  cssAttrComma         = { fg = purple },
  cssAttributeSelector = { fg = green },
  cssBraces            = { fg = white },
  cssClassName         = { fg = orange },
  cssClassNameDot      = { fg = orange },
  cssDefinition        = { fg = purple },
  cssFontAttr          = { fg = orange },
  cssFontDescriptor    = { fg = purple },
  cssFunctionName      = { fg = blue },
  cssIdentifier        = { fg = blue },
  cssImportant         = { fg = purple },
  cssInclude           = { fg = white },
  cssIncludeKeyword    = { fg = purple },
  cssMediaType         = { fg = orange },
  cssProp              = { fg = white },
  cssPseudoClassId     = { fg = orange },
  cssSelectorOp        = { fg = purple },
  cssSelectorOp2       = { fg = purple },
  cssTagName           = { fg = red },

  -- Fish Shell
  fishKeyword     = { fg = purple },
  fishConditional = { fg = purple },

  -- Go
  goDeclaration  = { fg = purple },
  goBuiltins     = { fg = cyan },
  goFunctionCall = { fg = blue },
  goVarDefs      = { fg = red },
  goVarAssign    = { fg = red },
  goVar          = { fg = purple },
  goConst        = { fg = purple },
  goType         = { fg = yellow },
  goTypeName     = { fg = yellow },
  goDeclType     = { fg = cyan },
  goTypeDecl     = { fg = purple },

  -- HTML (keep consistent with Markdown, below)
  htmlArg            = { fg = orange },
  htmlBold           = { fg = orange, bold = true },
  htmlEndTag         = { fg = white },
  htmlH1             = { fg = red },
  htmlH2             = { fg = red },
  htmlH3             = { fg = red },
  htmlH4             = { fg = red },
  htmlH5             = { fg = red },
  htmlH6             = { fg = red },
  htmlItalic         = { fg = purple, italic = true },
  htmlLink           = { fg = cyan, underline = true },
  htmlSpecialChar    = { fg = orange },
  htmlSpecialTagName = { fg = red },
  htmlTag            = { fg = white },
  htmlTagN           = { fg = red },
  htmlTagName        = { fg = red },
  htmlTitle          = { fg = white },

  -- JavaScript
  javaScriptBraces     = { fg = white },
  javaScriptFunction   = { fg = purple },
  javaScriptIdentifier = { fg = purple },
  javaScriptNull       = { fg = orange },
  javaScriptNumber     = { fg = orange },
  javaScriptRequire    = { fg = cyan },
  javaScriptReserved   = { fg = purple },
  -- http//github.com/pangloss/vim-javascript
  jsArrowFunction   = { fg = purple },
  jsClassKeyword    = { fg = purple },
  jsClassMethodType = { fg = purple },
  jsDocParam        = { fg = blue },
  jsDocTags         = { fg = purple },
  jsExport          = { fg = purple },
  jsExportDefault   = { fg = purple },
  jsExtendsKeyword  = { fg = purple },
  jsFrom            = { fg = purple },
  jsFuncCall        = { fg = blue },
  jsFunction        = { fg = purple },
  jsGenerator       = { fg = yellow },
  jsGlobalObjects   = { fg = yellow },
  jsImport          = { fg = purple },
  jsModuleAs        = { fg = purple },
  jsModuleWords     = { fg = purple },
  jsModules         = { fg = purple },
  jsNull            = { fg = orange },
  jsOperator        = { fg = purple },
  jsStorageClass    = { fg = purple },
  jsSuper           = { fg = red },
  jsTemplateBraces  = { fg = dark_red },
  jsTemplateVar     = { fg = green },
  jsThis            = { fg = red },
  jsUndefined       = { fg = orange },
  -- http//github.com/othree/yajs.vim
  javascriptArrowFunc    = { fg = purple },
  javascriptClassExtends = { fg = purple },
  javascriptClassKeyword = { fg = purple },
  javascriptDocNotation  = { fg = purple },
  javascriptDocParamName = { fg = blue },
  javascriptDocTags      = { fg = purple },
  javascriptEndColons    = { fg = white },
  javascriptExport       = { fg = purple },
  javascriptFuncArg      = { fg = white },
  javascriptFuncKeyword  = { fg = purple },
  javascriptIdentifier   = { fg = red },
  javascriptImport       = { fg = purple },
  javascriptMethodName   = { fg = white },
  javascriptObjectLabel  = { fg = white },
  javascriptOpSymbol     = { fg = cyan },
  javascriptOpSymbols    = { fg = cyan },
  javascriptPropertyName = { fg = green },
  javascriptTemplateSB   = { fg = dark_red },
  javascriptVariable     = { fg = purple },

  -- JSON
  jsonCommentError      = { fg = white },
  jsonKeyword           = { fg = red },
  jsonBoolean           = { fg = orange },
  jsonNumber            = { fg = orange },
  jsonQuote             = { fg = white },
  jsonMissingCommaError = { fg = red, reverse = true },
  jsonNoQuotesError     = { fg = red, reverse = true },
  jsonNumError          = { fg = red, reverse = true },
  jsonString            = { fg = green },
  jsonStringSQError     = { fg = red, reverse = true },
  jsonSemicolonError    = { fg = red, reverse = true },

  -- LESS
  lessVariable      = { fg = purple },
  lessAmpersandChar = { fg = white },
  lessClass         = { fg = orange },

  -- Markdown (keep consistent with HTML, above)
  markdownBlockquote        = { fg = comment_grey },
  markdownBold              = { fg = orange, bold = true },
  markdownCode              = { fg = green },
  markdownCodeBlock         = { fg = green },
  markdownCodeDelimiter     = { fg = green },
  markdownH1                = { fg = red },
  markdownH2                = { fg = red },
  markdownH3                = { fg = red },
  markdownH4                = { fg = red },
  markdownH5                = { fg = red },
  markdownH6                = { fg = red },
  markdownHeadingDelimiter  = { fg = red },
  markdownHeadingRule       = { fg = comment_grey },
  markdownId                = { fg = purple },
  markdownIdDeclaration     = { fg = blue },
  markdownIdDelimiter       = { fg = purple },
  markdownItalic            = { fg = purple, italic = true },
  markdownLinkDelimiter     = { fg = purple },
  markdownLinkText          = { fg = blue },
  markdownListMarker        = { fg = red },
  markdownOrderedListMarker = { fg = red },
  markdownRule              = { fg = comment_grey },
  markdownUrl               = { fg = cyan, underline = true },

  -- Perl
  perlFiledescRead      = { fg = green },
  perlFunction          = { fg = purple },
  perlMatchStartEnd     = { fg = blue },
  perlMethod            = { fg = purple },
  perlPOD               = { fg = comment_grey },
  perlSharpBang         = { fg = comment_grey },
  perlSpecialString     = { fg = orange },
  perlStatementFiledesc = { fg = red },
  perlStatementFlow     = { fg = red },
  perlStatementInclude  = { fg = purple },
  perlStatementScalar   = { fg = purple },
  perlStatementStorage  = { fg = purple },
  perlSubName           = { fg = yellow },
  perlVarPlain          = { fg = blue },

  -- PHP
  phpVarSelector    = { fg = red },
  phpOperator       = { fg = white },
  phpParent         = { fg = white },
  phpMemberSelector = { fg = white },
  phpType           = { fg = purple },
  phpKeyword        = { fg = purple },
  phpClass          = { fg = yellow },
  phpUseClass       = { fg = white },
  phpUseAlias       = { fg = white },
  phpInclude        = { fg = purple },
  phpClassExtends   = { fg = green },
  phpDocTags        = { fg = white },
  phpFunction       = { fg = blue },
  phpFunctions      = { fg = cyan },
  phpMethodsVar     = { fg = orange },
  phpMagicConstants = { fg = orange },
  phpSuperglobals   = { fg = red },
  phpConstants      = { fg = orange },

  -- Ruby
  rubyBlockParameter            = { fg = red },
  rubyBlockParameterList        = { fg = red },
  rubyClass                     = { fg = purple },
  rubyConstant                  = { fg = yellow },
  rubyControl                   = { fg = purple },
  rubyEscape                    = { fg = red },
  rubyFunction                  = { fg = blue },
  rubyGlobalVariable            = { fg = red },
  rubyInclude                   = { fg = blue },
  rubyIncluderubyGlobalVariable = { fg = red },
  rubyInstanceVariable          = { fg = red },
  rubyInterpolation             = { fg = cyan },
  rubyInterpolationDelimiter    = { fg = red },
  rubyRegexp                    = { fg = cyan },
  rubyRegexpDelimiter           = { fg = cyan },
  rubyStringDelimiter           = { fg = green },
  rubySymbol                    = { fg = cyan },

  -- Sass
  -- http//github.com/tpope/vim-haml
  sassAmpersand      = { fg = red },
  sassClass          = { fg = orange },
  sassControl        = { fg = purple },
  sassExtend         = { fg = purple },
  sassFor            = { fg = white },
  sassFunction       = { fg = cyan },
  sassId             = { fg = blue },
  sassInclude        = { fg = purple },
  sassMedia          = { fg = purple },
  sassMediaOperators = { fg = white },
  sassMixin          = { fg = purple },
  sassMixinName      = { fg = blue },
  sassMixing         = { fg = purple },
  sassVariable       = { fg = purple },
  -- http//github.com/cakebaker/scss-syntax.vim
  scssExtend       = { fg = purple },
  scssImport       = { fg = purple },
  scssInclude      = { fg = purple },
  scssMixin        = { fg = purple },
  scssSelectorName = { fg = orange },
  scssVariable     = { fg = purple },

  -- TeX
  texStatement    = { fg = purple },
  texSubscripts   = { fg = orange },
  texSuperscripts = { fg = orange },
  texTodo         = { fg = dark_red },
  texBeginEnd     = { fg = purple },
  texBeginEndName = { fg = blue },
  texMathMatcher  = { fg = blue },
  texMathDelim    = { fg = blue },
  texDelimiter    = { fg = orange },
  texSpecialChar  = { fg = orange },
  texCite         = { fg = blue },
  texRefZone      = { fg = blue },

  -- TypeScript
  typescriptReserved  = { fg = purple },
  typescriptEndColons = { fg = white },
  typescriptBraces    = { fg = white },

  -- XML
  xmlAttrib  = { fg = orange },
  xmlEndTag  = { fg = red },
  xmlTag     = { fg = red },
  xmlTagName = { fg = red },

  -- plasticboy/vim-markdown (keep consistent with Markdown, above)
  mkdDelimiter = { fg = purple },
  mkdHeading   = { fg = red },
  mkdLink      = { fg = blue },
  mkdURL       = { fg = cyan, underline = true },

  -- tpope/vim-fugitive
  diffAdded   = { fg = green },
  diffRemoved = { fg = red },
  diffChanged = { fg = yellow },

  -- lewis6991/gitsigns.nvim
  GitSignsAdd              = { fg = green },
  GitSignsChange           = { fg = yellow },
  GitSignsDelete           = { fg = red },
  GitSignsCurrentLineBlame = { fg = comment_grey },

  -- Git Highlighting
  gitcommitComment        = { fg = comment_grey },
  gitcommitUnmerged       = { fg = green },
  gitcommitOnBranch       = { },
  gitcommitBranch         = { fg = purple },
  gitcommitDiscardedType  = { fg = red },
  gitcommitSelectedType   = { fg = green },
  gitcommitHeader         = { },
  gitcommitUntrackedFile  = { fg = cyan },
  gitcommitDiscardedFile  = { fg = red },
  gitcommitSelectedFile   = { fg = green },
  gitcommitUnmergedFile   = { fg = yellow },
  gitcommitFile           = { },
  gitcommitSummary        = { fg = white },
  gitcommitOverflow       = { fg = red },
  gitcommitNoBranch       = { link = 'gitcommitBranch' },
  gitcommitUntracked      = { link = 'gitcommitComment' },
  gitcommitDiscarded      = { link = 'gitcommitComment' },
  gitcommitSelected       = { link = 'gitcommitComment' },
  gitcommitDiscardedArrow = { link = 'gitcommitDiscardedFile' },
  gitcommitSelectedArrow  = { link = 'gitcommitSelectedFile' },
  gitcommitUnmergedArrow  = { link = 'gitcommitUnmergedFile' },

  -- diffview
  DiffviewNormal            = { link = 'Dim' },
  DiffviewFilePanelTitle    = { fg = blue },
  DiffviewFilePanelFileName = { fg = white },
  DiffviewNonText           = { fg = comment_grey },

  -- lir
  LirDir          = { fg = blue },
  LirSymLink      = { fg = cyan },
  LirEmptyDirText = { fg = white },

  -- cmp
  CmpItemAbbr           = { fg = white },
  CmpItemAbbrDeprecated = { fg = light_grey },
  CmpItemKind           = { fg = blue },
  CmpItemMenu           = { fg = comment_grey },

  neoreplOutput = { fg = green, bg = dim },
  neoreplValue  = { fg = orange, bg = dim },
  neoreplError  = { fg = red, bg = dim },
  neoreplInfo   = { fg = blue, bg = dim },

  -- ['@keyword'] = { fg = purple },
  -- ['@variable'] = { fg = white },
  -- ['@property'] = { fg = white },
  -- ['@parameter'] = { fg = white },
}

-- Neovim diagnostics
if vim.env.TERM == 'xterm-kitty' or vim.env.TERM == 'alacritty' then
  theme.DiagnosticUnderlineError = { underline = true, special = red }
  theme.DiagnosticUnderlineWarn  = { underline = true, special = yellow }
  theme.DiagnosticUnderlineInfo  = { underline = true, special = blue }
  theme.DiagnosticUnderlineHint  = { underline = true, special = cyan }
end

-- Neovim terminal colors
vim.g.terminal_color_0  = visual_grey
vim.g.terminal_color_1  = red
vim.g.terminal_color_2  = green
vim.g.terminal_color_3  = yellow
vim.g.terminal_color_4  = blue
vim.g.terminal_color_5  = purple
vim.g.terminal_color_6  = cyan
vim.g.terminal_color_7  = white
vim.g.terminal_color_8  = visual_grey
vim.g.terminal_color_9  = dark_red
vim.g.terminal_color_10 = green
vim.g.terminal_color_11 = orange
vim.g.terminal_color_12 = blue
vim.g.terminal_color_13 = purple
vim.g.terminal_color_14 = cyan
vim.g.terminal_color_15 = comment_grey
vim.g.terminal_color_background = black
vim.g.terminal_color_foreground = white

-- lightbulb
vim.fn.sign_define('LightBulbSign', { text = '?', texthl = 'Number' })

vim.o.winhighlight = 'SpecialKey:SpecialKeyWin'

local set_hl = vim.api.nvim_set_hl
for k, v in pairs(theme) do
  set_hl(0, k, v)
end

-- stylua: ignore end
