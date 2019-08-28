{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dmenu
    haskellPackages.yeganesh
    kitty
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
