{ config, pkgs,  ... }:
let
  # there is no extra definition for x240
  thinkpad-x250 = "${(builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz")}/lenovo/thinkpad/x250";
in
{
  imports = [
    thinkpad-x250
    ../default.nix
    ./audio.nix
    ./backlight.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "x240";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;
}
