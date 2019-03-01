{ config, pkgs,  ... }:
with builtins;
with pkgs;
let
  home-manager = import (
    fetchTarball https://github.com/rycee/home-manager/archive/release-18.09.tar.gz
    ) { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      home-manager.nixos
    ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.wireless.enable = true;

    time.timeZone = "Europe/Berlin";

    environment.systemPackages = with pkgs; [
      neovim
      git
      home-manager.home-manager
    ];

  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  # this creates or activates the most recent profile on login, which means
  # that later changes to the profile by the will not be overridden by a system
  # rebuild
  home-manager.users.vg =
    let config = fetchGit {
      url = "https://github.com/fricklerhandwerk/.config";
      ref = "master";
    };
    in (import config) "${config}";

  system.stateVersion = "18.09";
}
