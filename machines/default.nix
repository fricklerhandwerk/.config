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
    pulseaudio-ctl
  ];

  # resolve `.local` domains
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  programs.fish.enable = true;

  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" ];
    shell = pkgs.fish;
  };

  home-config.users.vg = {
    repo = https://github.com/fricklerhandwerk/.config;
    file = "home-manager/default.nix";
  };
}
