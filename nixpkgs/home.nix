{ pkgs, ... }:
with builtins;
{
  imports = [
    ./secrets.nix
    ./xmonad
  ];
  home.packages = with pkgs; [
    qutebrowser
    ranger
    afpfs-ng
    vlc
  ];
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
