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
    dzen2
    conky
  ];
  fonts.fontconfig.enableProfileFonts = true;
  xdg.configFile."xmobar/xmobarrc".source = ./xmobarrc;
}
