{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/ata-OCZ-ONYX_273K6Q20DXA22LRV81C5";

  networking.hostName = "ga-x58";
  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;

  hardware.pulseaudio.enable = true;

  # install closed-source drivers for broadcom WLAN adapter
  nixpkgs.config.allowUnfree = true;
}
