{ pkgs, ... }:
{
  imports = [
    ../.
    ./dunst.nix
    ./xmonad.nix
  ];

  home.packages = with pkgs; [
    qutebrowser
    tor-browser
    vlc
    wine
    winetricks
    unstable.discord
  ];
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
  # auto-mount external storage
  services.udiskie.enable = true;
}
