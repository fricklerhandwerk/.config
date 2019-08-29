import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import System.IO

main = do
  xmobar <- spawnPipe "xmobar"
  xmonad $ docks defaultConfig
    { modMask = mod4Mask
    , terminal = "kitty"
    , borderWidth = 3
    , focusFollowsMouse = False
    , layoutHook = smartBorders $ avoidStruts $ layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP { ppOutput = hPutStrLn xmobar }
    } `additionalKeys`
    [ ((mod4Mask, xK_Return), spawn "$(yeganesh -x)")
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]
