import XMonad
import XMonad.Util.EZConfig(additionalKeys)
main = xmonad $ defaultConfig
  { modMask = mod4Mask
  -- pass config as command line parameters for now to prevent creating more
  -- dotfiles. eventually there should be a setup to create an XResources file
  -- in a custom location.
  , terminal = "uxterm -ls \
               \ -fa 'Ubuntu Mono' \
               \ -xrm '*selectToClipboard: true' \
               \ -xrm '*metaSendsEscape: true'"
  , borderWidth = 3
  , focusFollowsMouse = False
  } `additionalKeys`
  [ ((mod4Mask, xK_Return), spawn "dmenu_run")
  ]
