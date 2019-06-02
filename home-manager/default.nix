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
    acpi
  ];
  programs.fish = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
