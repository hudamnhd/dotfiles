-- WHETHER TO APPLY CURRENT COLOR SCHEME
local apply_colorscheme = true

-- Palettes ===================================================================
local bg = {
  cyan   = "#006060",
  green  = "#00481e",
  red    = "#62000a",
  yellow = "#705800",
}
local c = {
  blue    = "#7aabcc",
  cyan    = "#64baba",
  green   = "#84b98e",
  black1  = "#1b1b1b",
  black2  = "#363a3f",
  black3  = "#4e5257",
  grey1   = "#cccccc",
  grey2   = "#a2a7ab",
  grey3   = "#898f93",
  magenta = "#c897c3",
  red     = "#e5a6a0",
  yellow  = "#bea86b",
}



-- Highlight groups ===========================================================
-- A function which defines highlight groups same way as the PR.
-- Uncomment later call to this function for quick prototyping.

local enable_colorscheme = function()
  vim.cmd('hi clear')
  vim.g.colors_name = 'custom'

  --stylua: ignore start
  local hi = function(name, data) vim.api.nvim_set_hl(0, name, data) end

  -- General UI
  hi('ColorColumn', { fg = nil, bg = c.black2 })
  hi('Conceal', { fg = c.black3, bg = nil })
  hi('CurSearch', { fg = c.black1, bg = c.grey1 })
  hi('Cursor', { fg = nil, bg = nil })
  hi('CursorColumn', { fg = nil, bg = c.black2 })
  hi('CursorIM', { link = 'Cursor' })
  hi('CursorLine', { fg = nil, bg = c.black2 })
  hi('CursorLineFold', { link = 'FoldColumn' })
  hi('CursorLineNr', { fg = nil, bg = nil, bold = true })
  hi('CursorLineSign', { link = 'SignColumn' })
  hi('DiffAdd', { fg = c.grey1, bg = bg.green })
  hi('DiffChange', { fg = c.grey1, bg = c.black3 })
  hi('DiffDelete', { fg = c.red, bg = nil, bold = true })
  hi('DiffText', { fg = c.grey1, bg = bg.cyan })
  hi('Directory', { fg = c.cyan, bg = nil })
  hi('EndOfBuffer', { link = 'NonText' })
  hi('ErrorMsg', { fg = c.red, bg = nil })
  hi('FloatBorder', { link = 'NormalFloat' })
  hi('FloatFooter', { link = 'FloatTitle' })
  hi('FloatShadow', { fg = nil, bg = c.black3, blend = 80 })
  hi('FloatShadowThrough', { fg = nil, bg = c.black3, blend = 100 })
  hi('FloatTitle', { link = 'Title' })
  hi('FoldColumn', { link = 'SignColumn' })
  hi('Folded', { fg = c.grey3, bg = c.black2 })
  hi('IncSearch', { link = 'CurSearch' })
  hi('lCursor', { fg = c.black1, bg = c.grey1 })
  hi('LineNr', { fg = c.black3, bg = nil })
  hi('LineNrAbove', { link = 'LineNr' })
  hi('LineNrBelow', { link = 'LineNr' })
  hi('MatchParen', { fg = nil, bg = c.black3, bold = true })
  hi('ModeMsg', { fg = c.green, bg = nil })
  hi('MoreMsg', { fg = c.cyan, bg = nil })
  hi('MsgArea', { fg = nil, bg = nil })
  hi('MsgSeparator', { link = 'StatusLine' })
  hi('NonText', { fg = c.black3, bg = nil })
  hi('Normal', { fg = c.grey1, bg = c.black1 })
  hi('NormalFloat', { fg = nil, bg = c.black1 })
  hi('NormalNC', { fg = nil, bg = nil })
  hi('PMenu', { fg = nil, bg = c.black2 })
  hi('PMenuExtra', { link = 'PMenu' })
  hi('PMenuExtraSel', { link = 'PMenuSel' })
  hi('PMenuKind', { link = 'PMenu' })
  hi('PMenuKindSel', { link = 'PMenuSel' })
  hi('PMenuSbar', { link = 'PMenu' })
  hi('PMenuSel', { fg = c.black2, bg = c.grey1, blend = 0 })
  hi('PMenuThumb', { fg = nil, bg = c.black3 })
  hi('Question', { fg = c.cyan, bg = nil })
  hi('QuickFixLine', { fg = c.cyan, bg = nil })
  hi('RedrawDebugNormal', { fg = nil, bg = nil, reverse = true })
  hi('RedrawDebugClear', { fg = nil, bg = bg.cyan })
  hi('RedrawDebugComposed', { fg = nil, bg = bg.green })
  hi('RedrawDebugRecompose', { fg = nil, bg = bg.red })
  hi('Search', { fg = c.grey1, bg = bg.yellow })
  hi('SignColumn', { fg = c.black3, bg = nil })
  hi('SpecialKey', { fg = c.black3, bg = nil })
  hi('SpellBad', { fg = nil, bg = nil, sp = c.red, undercurl = true })
  hi('SpellCap', { fg = nil, bg = nil, sp = c.yellow, undercurl = true })
  hi('SpellLocal', { fg = nil, bg = nil, sp = c.green, undercurl = true })
  hi('SpellRare', { fg = nil, bg = nil, sp = c.cyan, undercurl = true })
  hi('StatusLine', { fg = c.grey2, bg = c.black1 })
  hi('StatusLineNC', { fg = c.grey3, bg = c.black1 })
  hi('Substitute', { link = 'Search' })
  hi('TabLine', { fg = c.grey2, bg = c.black1 })
  hi('TabLineFill', { link = 'Tabline' })
  hi('TabLineSel', { fg = nil, bg = nil, bold = true })
  hi('TermCursor', { fg = nil, bg = nil, reverse = true })
  hi('TermCursorNC', { fg = nil, bg = nil })
  hi('Title', { fg = nil, bg = nil, bold = true })
  hi('VertSplit', { link = 'WinSeparator' })
  hi('Visual', { fg = nil, bg = c.black3 })
  hi('VisualNOS', { link = 'Visual' })
  hi('WarningMsg', { fg = c.yellow, bg = nil })
  hi('Whitespace', { link = 'NonText' })
  hi('WildMenu', { link = 'PMenuSel' })
  hi('WinBar', { link = 'StatusLine' })
  hi('WinBarNC', { link = 'StatusLineNC' })
  -- hi('WinSeparator', { link = 'Normal' })
  hi('WinSeparator', { fg = c.black1, bg = c.black1 })

  -- Syntax (`:h group-name`)
  hi('Comment', { fg = c.grey3, bg = nil })

  hi('Constant', { fg = nil, bg = nil })
  hi('String', { fg = c.green, bg = nil })
  hi('Character', { link = 'Constant' })
  hi('Number', { link = 'Constant' })
  hi('Boolean', { link = 'Constant' })
  hi('Float', { link = 'Number' })

  hi('Identifier', { fg = c.blue, bg = nil })          -- frequent but important to get "main" branded color
  hi('Function', { fg = c.cyan, bg = nil })            -- not so frequent but important to get "main" branded color

  hi('Statement', { fg = nil, bg = nil, bold = true }) -- bold choice (get it?) for accessibility
  hi('Conditional', { link = 'Statement' })
  hi('Repeat', { link = 'Statement' })
  hi('Label', { link = 'Statement' })
  hi('Operator', { fg = nil, bg = nil }) -- seems too much to be bold for mostly singl-character words
  hi('Keyword', { link = 'Statement' })
  hi('Exception', { link = 'Statement' })

  hi('PreProc', { fg = nil, bg = nil })
  hi('Include', { link = 'PreProc' })
  hi('Define', { link = 'PreProc' })
  hi('Macro', { link = 'PreProc' })
  hi('PreCondit', { link = 'PreProc' })

  hi('Type', { fg = nil, bg = nil })
  hi('StorageClass', { link = 'Type' })
  hi('Structure', { link = 'Type' })
  hi('Typedef', { link = 'Type' })

  hi('Special', { fg = c.cyan, bg = nil }) -- not so frequent but important to get "main" branded color
  hi('Tag', { link = 'Special' })
  hi('SpecialChar', { link = 'Special' })
  hi('Delimiter', { fg = nil, bg = nil })
  hi('SpecialComment', { link = 'Special' })
  hi('Debug', { link = 'Special' })

  hi('LspInlayHint', { link = 'NonText' })
  hi('SnippetTabstop', { link = 'Visual' })

  hi('Underlined', { fg = nil, bg = nil, underline = true })
  hi('Ignore', { link = 'Normal' })
  hi('Error', { fg = c.black1, bg = bg.red })
  hi('Todo', { fg = c.grey1, bg = nil, bold = true })

  hi('diffAdded', { fg = c.green, bg = nil })
  hi('diffRemoved', { fg = c.red, bg = nil })

  -- Built-in diagnostic
  hi('DiagnosticError', { fg = c.red, bg = nil })
  hi('DiagnosticWarn', { fg = c.yellow, bg = nil })
  hi('DiagnosticInfo', { fg = c.cyan, bg = nil })
  hi('DiagnosticHint', { fg = c.blue, bg = nil })
  hi('DiagnosticOk', { fg = c.green, bg = nil })

  hi('DiagnosticUnderlineError', { fg = nil, bg = nil, sp = c.red, underline = true })
  hi('DiagnosticUnderlineWarn', { fg = nil, bg = nil, sp = c.yellow, underline = true })
  hi('DiagnosticUnderlineInfo', { fg = nil, bg = nil, sp = c.cyan, underline = true })
  hi('DiagnosticUnderlineHint', { fg = nil, bg = nil, sp = c.blue, underline = true })
  hi('DiagnosticUnderlineOk', { fg = nil, bg = nil, sp = c.green, underline = true })

  hi('DiagnosticFloatingError', { fg = c.red, bg = c.black1 })
  hi('DiagnosticFloatingWarn', { fg = c.yellow, bg = c.black1 })
  hi('DiagnosticFloatingInfo', { fg = c.cyan, bg = c.black1 })
  hi('DiagnosticFloatingHint', { fg = c.blue, bg = c.black1 })
  hi('DiagnosticFloatingOk', { fg = c.green, bg = c.black1 })

  hi('DiagnosticVirtualTextError', { link = 'DiagnosticError' })
  hi('DiagnosticVirtualTextWarn', { link = 'DiagnosticWarn' })
  hi('DiagnosticVirtualTextInfo', { link = 'DiagnosticInfo' })
  hi('DiagnosticVirtualTextHint', { link = 'DiagnosticHint' })
  hi('DiagnosticVirtualTextOk', { link = 'DiagnosticOk' })

  hi('DiagnosticSignError', { link = 'DiagnosticError' })
  hi('DiagnosticSignWarn', { link = 'DiagnosticWarn' })
  hi('DiagnosticSignInfo', { link = 'DiagnosticInfo' })
  hi('DiagnosticSignHint', { link = 'DiagnosticHint' })
  hi('DiagnosticSignOk', { link = 'DiagnosticOk' })

  hi('DiagnosticDeprecated', { fg = nil, bg = nil, sp = bg.red, strikethrough = true })
  hi('DiagnosticUnnecessary', { link = 'Comment' })

  -- Tree-sitter
  -- - Text
  hi('@text.literal', { link = 'Comment' })
  hi('@text.reference', { link = 'Identifier' })
  hi('@text.title', { link = 'Title' })
  hi('@text.uri', { link = 'Underlined' })
  hi('@text.underline', { link = 'Underlined' })
  hi('@text.todo', { link = 'Todo' })

  -- - Miscs
  hi('@comment', { link = 'Comment' })
  hi('@punctuation', { link = 'Delimiter' })

  -- - Constants
  hi('@constant', { link = 'Constant' })
  hi('@constant.builtin', { link = 'Special' })
  hi('@constant.macro', { link = 'Define' })
  hi('@define', { link = 'Define' })
  hi('@macro', { link = 'Macro' })
  hi('@string', { link = 'String' })
  hi('@string.escape', { link = 'SpecialChar' })
  hi('@string.special', { link = 'SpecialChar' })
  hi('@character', { link = 'Character' })
  hi('@character.special', { link = 'SpecialChar' })
  hi('@number', { link = 'Number' })
  hi('@boolean', { link = 'Boolean' })
  hi('@float', { link = 'Float' })

  -- - Functions
  hi('@function', { link = 'Function' })
  hi('@function.builtin', { link = 'Special' })
  hi('@function.macro', { link = 'Macro' })
  hi('@parameter', { link = 'Identifier' })
  hi('@method', { link = 'Function' })
  hi('@field', { link = 'Identifier' })
  hi('@property', { link = 'Identifier' })
  hi('@constructor', { link = 'Special' })

  -- - Keywords
  hi('@conditional', { link = 'Conditional' })
  hi('@repeat', { link = 'Repeat' })
  hi('@label', { link = 'Label' })
  hi('@operator', { link = 'Operator' })
  hi('@keyword', { link = 'Keyword' })
  hi('@exception', { link = 'Exception' })

  hi('@variable', { fg = nil, bg = nil }) -- using default foreground reduces visual overload
  hi('@type', { link = 'Type' })
  hi('@type.definition', { link = 'Typedef' })
  hi('@storageclass', { link = 'StorageClass' })
  hi('@namespace', { link = 'Identifier' })
  hi('@include', { link = 'Include' })
  hi('@preproc', { link = 'PreProc' })
  hi('@debug', { link = 'Debug' })
  hi('@tag', { link = 'Tag' })

  -- - LSP semantic tokens
  hi('@lsp.type.class', { link = 'Structure' })
  hi('@lsp.type.comment', { link = 'Comment' })
  hi('@lsp.type.decorator', { link = 'Function' })
  hi('@lsp.type.enum', { link = 'Structure' })
  hi('@lsp.type.enumMember', { link = 'Constant' })
  hi('@lsp.type.function', { link = 'Function' })
  hi('@lsp.type.interface', { link = 'Structure' })
  hi('@lsp.type.macro', { link = 'Macro' })
  hi('@lsp.type.method', { link = 'Function' })
  hi('@lsp.type.namespace', { link = 'Structure' })
  hi('@lsp.type.parameter', { link = 'Identifier' })
  hi('@lsp.type.property', { link = 'Identifier' })
  hi('@lsp.type.struct', { link = 'Structure' })
  hi('@lsp.type.type', { link = 'Type' })
  hi('@lsp.type.typeParameter', { link = 'TypeDef' })
  hi('@lsp.type.variable', { link = '@variable' }) -- links to tree-sitter group to reduce overload

  hi('MiniStatuslineModeNormal', { fg = c.black1, bg = c.cyan })
  hi('MiniStatuslineModeInsert', { fg = c.black1, bg = c.blue })
  hi('MiniStatuslineModeVisual', { fg = c.black1, bg = c.magenta })
  hi('MiniStatuslineModeReplace', { fg = c.black1, bg = c.yellow })
  hi('MiniStatuslineModeCommand', { fg = c.black1, bg = c.red })

  hi('MiniTablineFill', { link = 'Comment' })
  hi('MiniTablineHidden', { link = 'Comment' })
  hi('MiniTablineCurrent', { fg = c.black1, bg = c.grey1 })
  hi('MiniTablineVisible', { fg = c.black1, bg = c.grey1 })
  hi('MiniTablineModifiedHidden', { fg = c.black1, bg = c.red })
  hi('MiniTablineTabpagesection', { fg = c.black1, bg = c.cyan })
  hi('MiniTablineModifiedCurrent', { fg = c.black1, bg = c.blue })
  hi('MiniTablineModifiedVisible', { fg = c.black1, bg = c.magenta })

  --stylua: ignore end
end


-- Comment this to not enable color scheme
if apply_colorscheme then
  enable_colorscheme()
end
