{ config, pkgs,  ... }:
with config;
{
  imports = [
    ../modules/home-config.nix
  ];
  system.stateVersion = "18.09";

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager
    pulseaudio-ctl
  ];

  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" ];
  };
  home-config.users.vg.repo = https://github.com/fricklerhandwerk/.config;
}
