{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dmenu
  ];
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Util.EZConfig(additionalKeys)
        main = xmonad $ defaultConfig
          { modMask = mod4Mask
          , terminal = "uxterm -fa 'Ubuntu Mono' -ls -xrm 'UXTerm*selectToClipboard: true'"
          , borderWidth = 3
          , focusFollowsMouse = False
          } `additionalKeys`
          [ ((mod4Mask, xK_Return), spawn "dmenu_run")
          ]
      '';
    };
  };
}
