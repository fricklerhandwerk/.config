import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import System.IO

main = do
  spawn "while true; do date +'%a. %Y-%m-%d %H:%M'; sleep 2; done | dzen2 -dock -fn Ubuntu"
  xmonad $ docks defaultConfig
    { modMask = mod4Mask
    , terminal = "kitty"
    , borderWidth = 3
    , focusFollowsMouse = False
    , layoutHook = smartBorders $ avoidStruts $ layoutHook defaultConfig
    } `additionalKeys`
    [ ((mod4Mask, xK_Return), spawn "$(yeganesh -x)")
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]
