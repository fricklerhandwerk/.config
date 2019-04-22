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
      config = ./config.hs;
    };
  };
}
