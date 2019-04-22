{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dmenu
    haskellPackages.yeganesh
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
