{ pkgs, ... }:
{
  imports = [
    ../..
    ./xmonad
    ./secrets.nix
    ./udiskie.nix
    ./ssh-agent.nix
  ];

  home.packages = with pkgs; [
    acpi
    afpfs-ng
  ];

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
