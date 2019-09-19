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

  networking.hostName = "x240";
  time.timeZone = "Europe/Berlin";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;
  hardware.opengl.driSupport32Bit = true;
}
