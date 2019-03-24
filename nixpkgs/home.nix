{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qutebrowser
  ];
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        main = xmonad defaultConfig {
          terminal = "uxterm -fa 'Ubuntu Mono'"
        , borderWidth = 3
        }
      '';
    };
  };
}
