Config { font = "FiraCode Nerd Font Bold 10"
       , additionalFonts =
          [ "FontAwesome 12"
          , "FontAwesome Bold 8"
          , "FontAwesome 14"
          , "Hack 19"
          , "Hack 14"
          ]
       , border = NoBorder
       , bgColor = "#222436"
       , fgColor = "#c8d3f5"
       , alpha = 255
       , position = TopSize L 100 40
       -- , textOffset = 24
       -- , textOffsets = [ 25, 24 ]
       , lowerOnStart = True
       , allDesktops = True
       , persistent = False
       , hideOnStart = False
       , iconRoot = "/home/hudamnhd/.config/xmonad/xmobar/icons/"
       , commands =
         [ Run UnsafeXPropertyLog "_XMONAD_LOG_0"
         , Run Date "%a, %d %b <fn=1>󰥔</fn> %H:%M:%S" "date" 10
         , Run Com "/home/hudamnhd/.config/xmonad/xmobar/memory.sh" [] "memory" 10
         , Run Com "/home/hudamnhd/.config/xmonad/xmobar/volume.sh" [] "volume" 10
         , Run Com "/home/hudamnhd/.config/xmonad/xmobar/speed.sh" [] "speed" 10
         , Run Com "/home/hudamnhd/.config/xmonad/xmobar/keyboard_layout.sh" [] "keyboard_layout" 10
         ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "\
            \  \
            \%_XMONAD_LOG_0%\
            \}\
            \<action=xdotool key super+d>%date%</action>\
            \{\
            \<action=xdotool key super+y>%memory%</action>\
            \  \
            \|\
	    \  \
            \<action=xdotool key super+s p>%volume%</action>\
            \  \
            \|\
            \  \
            \%speed%\
            \  \
            \|\
            \  \
            \%keyboard_layout%\
            \  \
            \"
       }
