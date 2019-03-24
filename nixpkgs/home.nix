{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qutebrowser
  ];
  xsession = {
    enable = true;
    windowManager.xmonad.enable = true;
  };
}
