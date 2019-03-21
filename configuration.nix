{ config, pkgs,  ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/home-config.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.wireless.enable = true;

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager
  ];

  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  home-config.users.vg.repo = https://github.com/fricklerhandwerk/.config;

  system.stateVersion = "18.09";
}
