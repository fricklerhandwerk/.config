{ config, pkgs,  ... }:
let
  thinkpad-x240 = let
    src = builtins.fetchGit {
      url = https://github.com/NixOS/nixos-hardware;
      ref = "master";
    };
  # there is no extra definition for x240
  in "${src}/lenovo/thinkpad/x250";
in
{
  imports = [
    ../default.nix
    thinkpad-x240
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
