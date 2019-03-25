{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dmenu
    qutebrowser
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
          { terminal = "uxterm -fa 'Ubuntu Mono'"
          , borderWidth = 3
          } `additionalKeys`
          [ ((mod1Mask, xK_p), spawn "dmenu_run")
          ]
      '';
    };
  };
}
