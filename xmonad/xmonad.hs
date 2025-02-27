{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
import           Control.Monad                       (unless, when)
import           Data.Bits                           (testBit)
import           Data.Foldable                       (find)
import qualified Data.Map                            as M
import           Data.Maybe                          (fromJust)
import           Data.Semigroup
import           Foreign.C                           (CInt)
import           Graphics.X11.Xinerama               (getScreenInfo)
import           Prelude                             hiding (log)
import           System.Exit
import           XMonad
import qualified XMonad.StackSet                     as W


import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.InsertPosition         (Focus (Newer),
                                                      Position (End, Master),
                                                      insertPosition)
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers          (doCenterFloat, doSink,
                                                      isDialog)
import           XMonad.Hooks.OnPropertyChange
import           XMonad.Hooks.RefocusLast            (isFloat)
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.WindowSwallowing

import           XMonad.Layout.Decoration            (ModifiedLayout)
import           XMonad.Layout.DraggingVisualizer    (draggingVisualizer)
import           XMonad.Layout.HintedGrid
import           XMonad.Layout.IndependentScreens
import qualified XMonad.Layout.Magnifier             as Mag
import           XMonad.Layout.MouseResizableTile
import           XMonad.Layout.MultiToggle           (EOT (EOT),
                                                      Toggle (Toggle), mkToggle,
                                                      (??))
import           XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import           XMonad.Layout.NoBorders             (hasBorder, smartBorders)
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Renamed
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.Spacing               (Border (Border), Spacing,
                                                      spacingRaw)
import           XMonad.Layout.Tabbed

import qualified XMonad.Util.ExtensibleState         as XS
import           XMonad.Util.EZConfig                (additionalKeysP)
import           XMonad.Util.Loggers                 (logLayoutOnScreen,
                                                      logTitleOnScreen,
                                                      shortenL, wrapL,
                                                      xmobarColorL)
import           XMonad.Util.NamedScratchpad

import           Data.List
import qualified Data.List                           as L
import           XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize       as Flex
import           XMonad.Actions.OnScreen             (onlyOnScreen)
import           XMonad.Actions.TiledWindowDragging
import           XMonad.Actions.UpdatePointer        (updatePointer)
import           XMonad.Actions.Warp                 (warpToScreen)


myTerminal, myTerminalClass :: [Char]
myTerminal = "st"
myTerminalClass = "st-256color"

rofiMacro :: [Char]
rofiMacro = "rofi -show"

grey1, grey2, grey3, grey4, cyan, orange :: String
grey1  = "#222436"
grey2  = "#3B3F5E"
grey3  = "#7277A6"
grey4  = "#c8d3f5"
cyan   = "#82aaff"
orange = "#ff966c"

myWorkspaces :: [[Char]]
myWorkspaces = [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

trayerRestartCommand :: [Char]
trayerRestartCommand = "killall trayer; trayer --monitor 1 --edge top --align right --widthtype request --padding 7 --iconspacing 10 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x2B2E37  --height 29 --distance 5 &"

actionPrefix, actionButton, actionSuffix :: [Char]
actionPrefix = "<action=`xdotool key super+"
actionButton = "` button="
actionSuffix = "</action>"

addActions :: [(String, Int)] -> String -> String
addActions [] ws = ws
addActions (x:xs) ws = addActions xs (actionPrefix ++ k ++ actionButton ++ show b ++ ">" ++ ws ++ actionSuffix)
    where k = fst x
          b = snd x

------------------------------------------------------------------------

myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "htop" (myTerminal ++ " -t htop -e htop") (title =? "htop") (customFloating $ W.RationalRect 0.17 0.15 0.7 0.7)
  ]

------------------------------------------------------------------------

currentScreen :: X ScreenId
currentScreen = gets (W.screen . W.current . windowset)

isOnScreen :: ScreenId -> WindowSpace -> Bool
isOnScreen s ws = s == unmarshallS (W.tag ws)

workspaceOnCurrentScreen :: WSType
workspaceOnCurrentScreen = WSIs $ do
  s <- currentScreen
  return $ \x -> W.tag x /= "NSP" && isOnScreen s x

myAditionalKeys :: [(String, X ())]
myAditionalKeys =
-- https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html#v:checkKeymap
-- apps
  [ ("M-d",        spawn myTerminal)
  , ("M-p",        spawn "via")
  , ("M-t",        spawn "tabbed -r 2 st -w '' -e")
  , ("M-c",        spawn "~/.local/bin/rofi-custom")
  , ("M-<Delete>", spawn "rofi -show p -modi p:~/.local/bin/rofi-power-menu mouseprimary -theme-str 'entry {placeholder: \"\";} window {width: 15%;}'")
  , ("M-<Tab>",    spawn "~/.local/bin/rofi-window")
  , ("M-<F11>",    spawn "~/.local/bin/xkb-switch.sh")
  , ("M-<F12>",    spawn "~/.local/bin/screenrecord")
  , ("<Print>",    spawn "~/.local/bin/screenshot-full")
  , ("M-<Print>",  spawn "~/.local/bin/screenshot")
  , ("M-s k",      spawn "rofi -show p -modi p:~/.local/bin/rofi-calc.sh -theme-str 'entry {placeholder: \"\";} window {width: 15%;}'")
  , ("M-s d",      spawn "dmenu_run")
  , ("M-s e",      spawn "~/.local/bin/rofi-emoji")
  , ("M-s i",      spawn "~/.local/bin/rofi-icon")
  , ("M-s y",      spawn "st -e bash -i -c 'yy; exec bash'")
  , ("M-s f",      spawn "firefox")
  , ("M-s v",      spawn "vivaldi-stable")
  , ("M-s c",      spawn "pcmanfm")
  , ("M-s p",      spawn "pavucontrol")
  , ("M-S-t",      spawn trayerRestartCommand)

  , ("M-q", kill)

  -- scratchpads
  , ("M-y", namedScratchpadAction myScratchPads "htop")


  -- -- volume controls
  -- , ("M-<Print>", spawn "amixer set Master toggle")
  -- , ("M-<Scroll_lock>", spawn "amixer set Master 5%-")
  -- , ("M-<Pause>", spawn "amixer set Master 5%+")

  -- window controls
  , ("M-a", windows W.focusDown)
  , ("M-i", windows W.focusUp)
  , ("M-S-a", windows W.swapDown)
  , ("M-S-i", windows W.swapUp)
  , ("M-C-a", sendMessage ShrinkSlave)
  , ("M-C-i", sendMessage ExpandSlave)
  , ("M-h", windows W.focusMaster)
  , ("M-l", windows W.focusDown)
  , ("M-S-l", windows W.swapDown)
  , ("M-S-h", windows W.swapMaster)
  , ("M-<Return>", windows W.swapMaster)
  , ("M-C-h", sendMessage Shrink)
  , ("M-C-l", sendMessage Expand)
  , ("M-,", sendMessage $ IncMasterN 1)
  , ("M-.", sendMessage $ IncMasterN (-1))
  , ("M-<Space>", withFocused $ windows . W.sink)

  -- layout controls
  , ("M-w", sendMessage $ Toggle NBFULL)
  , ("M-S-w", sendMessage ToggleStruts)
  , ("M-n", sendMessage NextLayout)
  , ("M-m", spawn "xdotool key super+a && xdotool key super+A")
  , ("M-S-m", spawn "sleep 1; xset dpms force suspend")

  -- workspace controls
  , ("M-<Left>", moveTo Prev workspaceOnCurrentScreen)
  , ("M-<Right>", moveTo Next workspaceOnCurrentScreen)

  -- -- screen controll
  -- , ("M-o", switchScreen 1)
  -- , ("M-S-o", shiftNextScreen)

  -- kill / restart xmonad
  , ("M-S-q", io exitSuccess)
  , ("M-S-r", spawn "killall xmobar; xmonad --recompile; xmonad --restart")

  ]


myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $
 [((m .|. modm, k), windows $ onCurrentScreen f i)
 | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
 , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
 ]


myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList
  [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
  , ((modm .|. shiftMask, button1), dragWindow)
  , ((modm, button2), const kill)
  , ((modm, button3), \w -> focus w >> Flex.mouseResizeWindow w)
  , ((modm, button4), \_ -> moveTo Prev workspaceOnCurrentScreen)
  , ((modm, button5), \_ -> moveTo Next workspaceOnCurrentScreen)
  ]

------------------------------------------------------------------------

switchScreen :: Int -> X ()
switchScreen d = do s <- screenBy d
                    mws <- screenWorkspace s
                    warpToScreen s 0.618 0.618
                    case mws of
                         Nothing -> return ()
                         Just ws -> windows (W.view ws)

------------------------------------------------------------------------

mySpacing :: Integer -> Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i j = spacingRaw False (Border i i i i) True (Border j j j j) True

-- layoutThree = mkToggle (NBFULL ?? EOT) . renamed [Replace "ThreeCol"] $ Mag.magnifiercz' 1.3 $ draggingVisualizer $ smartBorders $ mySpacing 0 0 $ mouseResizableTile { masterFrac = 0.5, draggerType = FixedDragger 0 30}
-- layoutFloat = mkToggle (NBFULL ?? EOT) . renamed [Replace "float"] $ simpleFloat
myLayoutHook = avoidStruts $ onWorkspaces ["0_9"] layoutGrid $ layoutTall ||| layoutGrid ||| layoutTabbed
  where
    layoutTall = mkToggle (NBFULL ?? EOT) . renamed [Replace "tall"] $ draggingVisualizer $ smartBorders $ mySpacing 0 0 $ mouseResizableTile { masterFrac = 0.5, draggerType = FixedDragger 0 30}
    layoutGrid = mkToggle (NBFULL ?? EOT) . renamed [Replace "grid"] $ draggingVisualizer $ smartBorders $ mySpacing 0 0 $ Grid False
    layoutTabbed = mkToggle (NBFULL ?? EOT) . renamed [Replace "full"] $ smartBorders $ mySpacing 0 0 $ tabbed shrinkText myTabTheme
    myTabTheme = def
      { fontName            = "xft:FiraCode Nerd Font:size=12:bold"
      , activeColor         = grey2
      , inactiveColor       = grey1
      , activeBorderColor   = grey1
      , inactiveBorderColor = grey1
      , activeTextColor     = grey4
      , inactiveTextColor   = grey3
      , decoHeight          = 25
      }

------------------------------------------------------------------------

(~?) :: Eq a => Query [a] -> [a] -> Query Bool
q ~? x = fmap (x `L.isInfixOf`) q

(/=?) :: Eq a => Query a -> a -> Query Bool
q /=? x = fmap (/= x) q

myManageHook :: ManageHook
myManageHook = composeAll
  [ resource  =? "desktop_window" --> doIgnore
  , isDialog --> doCenterFloat
  , className =? "wow.exe" --> doCenterFloat
  , className =? "battle.net.exe" --> doCenterFloat
  , className =? "awakened-poe-trade" --> doCenterFloat
  , title =? "Godot" --> doCenterFloat
  , className =? "Blueberry.py" --> doCenterFloat
  , appName =? "blueman-manager" --> doCenterFloat
  , appName =? "pavucontrol" --> doCenterFloat
  , title =? myTerminalClass --> insertPosition End Newer
  , insertPosition Master Newer
  ] <+> manageDocks <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------

myHandleEventHook :: Event -> X All
myHandleEventHook = multiScreenFocusHook
                 -- <+> swallowEventHook (className =? myTerminalClass) (return True)
                --  <+> dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> doShift "1_8")

------------------------------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
	-- spawn trayerRestartCommand
        spawn "~/.local/bin/dynamic-wall.sh"
	spawn "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
	spawn "unclutter-xfixes"
	spawn "xrdb ~/.Xresources"
	spawn "xset r rate 210 40"
	spawn "setxkbmap -option 'caps:escape_shifted_capslock'"
	spawn "xrandr --output HDMI-A-0  --brightness 0.5"
	-- modify $ \xstate -> xstate { windowset = onlyOnScreen 1 "1_1" (windowset xstate) }

------------------------------------------------------------------------

newtype MyUpdatePointerActive = MyUpdatePointerActive Bool
instance ExtensionClass MyUpdatePointerActive where
  initialValue = MyUpdatePointerActive True

myUpdatePointer :: (Rational, Rational) -> (Rational, Rational) -> X ()
myUpdatePointer refPos ratio =
  whenX isActive $ do
    dpy <- asks display
    root <- asks theRoot
    (_,_,_,_,_,_,_,m) <- io $ queryPointer dpy root
    unless (testBit m 9 || testBit m 8 || testBit m 10) $ -- unless the mouse is clicking
      updatePointer refPos ratio

  where
    isActive = (\(MyUpdatePointerActive b) -> b) <$> XS.get

------------------------------------------------------------------------

multiScreenFocusHook :: Event -> X All
multiScreenFocusHook MotionEvent { ev_x = x, ev_y = y } = do
  ms <- getScreenForPos x y
  case ms of
    Just cursorScreen -> do
      let cursorScreenID = W.screen cursorScreen
      focussedScreenID <- gets (W.screen . W.current . windowset)
      when (cursorScreenID /= focussedScreenID) (focusWS $ W.tag $ W.workspace cursorScreen)
      return (All True)
    _ -> return (All True)
  where getScreenForPos :: CInt -> CInt
            -> X (Maybe (W.Screen WorkspaceId (Layout Window) Window ScreenId ScreenDetail))
        getScreenForPos x y = do
          ws <- windowset <$> get
          let screens = W.current ws : W.visible ws
              inRects = map (inRect x y . screenRect . W.screenDetail) screens
          return $ fst <$> find snd (zip screens inRects)
        inRect :: CInt -> CInt -> Rectangle -> Bool
        inRect x y rect = let l = fromIntegral (rect_x rect)
                              r = l + fromIntegral (rect_width rect)
                              t = fromIntegral (rect_y rect)
                              b = t + fromIntegral (rect_height rect)
                           in x >= l && x < r && y >= t && y < b
        focusWS :: WorkspaceId -> X ()
        focusWS ids = windows (W.view ids)
multiScreenFocusHook _ = return (All True)

------------------------------------------------------------------------

myWorkspaceIndices :: M.Map [Char] Integer
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..]

clickable :: [Char] -> [Char] -> [Char]
clickable icon ws = addActions [ (show i, 1), ("q", 2), ("Left", 4), ("Right", 5) ] icon
                    where i = fromJust $ M.lookup ws myWorkspaceIndices

myStatusBarSpawner :: Applicative f => ScreenId -> f StatusBarConfig
myStatusBarSpawner (S s) = do
                    pure $ statusBarPropTo ("_XMONAD_LOG_" ++ show s)
                          ("xmobar -x " ++ show s ++ " ~/.config/xmonad/xmobar/xmobar" ++ show s ++ ".hs")
                          (pure $ myXmobarPP (S s))


myXmobarPP :: ScreenId -> PP
myXmobarPP s  = filterOutWsPP [scratchpadWorkspaceTag] . marshallPP s $ def
  { ppSep = ""
  , ppWsSep = ""
  , ppCurrent = xmobarColor cyan "" . clickable wsIconFull
  , ppVisible = xmobarColor grey4 "" . clickable wsIconFull
  , ppVisibleNoWindows = Just (xmobarColor grey4 "" . clickable wsIconFull)
  , ppHidden = xmobarColor grey3 "" . clickable wsIconHidden
  , ppHiddenNoWindows = xmobarColor grey3 "" . clickable wsIconEmpty
  , ppUrgent = xmobarColor orange "" . clickable wsIconFull
  , ppOrder = \(ws : _ : _ : extras) -> ws : extras
  , ppExtras  = [ wrapL (actionPrefix ++ "n" ++ actionButton ++ "1>") actionSuffix
                $ wrapL (actionPrefix ++ "q" ++ actionButton ++ "2>") actionSuffix
                $ wrapL (actionPrefix ++ "Left" ++ actionButton ++ "4>") actionSuffix
                $ wrapL (actionPrefix ++ "Right" ++ actionButton ++ "5>") actionSuffix
                $ wrapL "    " "    " $ layoutColorIsActive s (logLayoutOnScreen s)
                , wrapL (actionPrefix ++ "q" ++ actionButton ++ "2>") actionSuffix
                $  titleColorIsActive s (shortenL 81 $ logTitleOnScreen s)
                ]
  }
  where
    wsIconFull   = " <fn=2>\xf111</fn>  "
    wsIconHidden = " <fn=2>\xf111</fn>  "
    wsIconEmpty  = " <fn=2>\xf10c</fn>  "
    titleColorIsActive n l = do
      c <- withWindowSet $ return . W.screen . W.current
      if n == c then xmobarColorL cyan "" l else xmobarColorL grey3 "" l
    layoutColorIsActive n l = do
      c <- withWindowSet $ return . W.screen . W.current
      if n == c then wrapL "<icon=/home/hudamnhd/.config/xmonad/xmobar/icons/" "_selected.xpm/>" l else wrapL "<icon=/home/hudamnhd/.config/xmonad/xmobar/icons/" ".xpm/>" l

------------------------------------------------------------------------

main :: IO ()
main = xmonad
       . ewmh
       . ewmhFullscreen
       . dynamicSBs myStatusBarSpawner
       . docks
       $ def
        { focusFollowsMouse  = True
        , clickJustFocuses   = False
        , borderWidth        = 2
        , modMask            = mod4Mask
        , normalBorderColor  = grey3
        , focusedBorderColor = cyan
        , terminal           = myTerminal
        , keys               = myKeys
        , workspaces         = withScreens 1 myWorkspaces
        , mouseBindings      = myMouseBindings
        , layoutHook         = myLayoutHook
        , manageHook         = myManageHook
        , startupHook        = myStartupHook

        -- , rootMask = rootMask def .|. pointerMotionMask
        -- , logHook            = logHook def <+> myUpdatePointer (0.75, 0.75) (0, 0)
        -- , handleEventHook    = myHandleEventHook
        } `additionalKeysP` myAditionalKeys
