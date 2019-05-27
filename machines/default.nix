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

  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };


  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" ];
  };
  home-config.users.vg.repo = https://github.com/fricklerhandwerk/.config;
  # TODO: if `home-config.users.<user>.file` is not the default, the
  # home-manager package for that user should be wrapped to use the
  # correct config file automatically.
}
