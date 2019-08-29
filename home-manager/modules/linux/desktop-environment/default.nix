{ pkgs, ... }:
{
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
    initExtra = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#404040'
    '';
  };
  home.packages = with pkgs; [
    dmenu
    kitty
    haskellPackages.yeganesh
    haskellPackages.xmobar
  ];
  xdg.configFile."xmobar/xmobarrc".source = ./xmobarrc;
}
