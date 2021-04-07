{ pkgs, lib, ... }:
{
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; [
        text-format-simple
      ];
      config = ./xmonad.hs;
    };
    initExtra = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#404040'
    '';
  };

  imports = [ ../../common/kitty.nix ];

  home.packages = with pkgs;
  let
    haskell = haskellPackages;
  in [
    dmenu
    haskell.yeganesh
    haskell.xmobar
    font-awesome_5
    ubuntu_font_family
  ];

  xdg.configFile."xmobar/xmobarrc".source = lib.mkDefault ./xmobarrc;
}
