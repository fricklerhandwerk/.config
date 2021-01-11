import Text.Format
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys, removeKeys)
import XMonad.Util.Run(spawnPipe)
import System.IO

main = do
  spawn Main.statusBar
  xmonad $ docks defaultConfig
    { modMask = super
    , XMonad.terminal = Main.terminal
    , borderWidth = 3
    , focusFollowsMouse = False
    , layoutHook = smartBorders $ avoidStruts $ layoutHook defaultConfig
    } `removeKeys`
    [ (super, xK_q) -- reloading programmatically does not clean up spawned processes
    ] `additionalKeys`
    [ ((super, xK_Return), spawn "$(yeganesh -x)")
    , ((super, xK_b), sendMessage ToggleStruts)
    , ((super, xK_r), spawn (format "pkill {0}; xmonad --restart" [Main.statusBar]))
    ]

super = mod4Mask
terminal = "kitty"
statusBar = "xmobar"
