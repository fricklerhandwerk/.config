{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-18.09.tar.gz}/nixos"
    ],
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.wireless.enable = true;

    time.timeZone = "Europe/Berlin";

    environment.systemPackages = with pkgs; [
      neovim
      home-manager
    ];

    system.activationScripts = {
      # this script will delete itself and the script to clone `.config`,
      # because it is needed only on the first build.
      firstInstall = {
        text = ''
          ${pkgs.gnused}/bin/sed '/firstInstall = /{:1;N;/};$/!b1};//d' -i /etc/nixos/configuration.nix
          ${pkgs.gnused}/bin/sed '/home = /{:1;N;/};$/!b1};//d' -i /etc/nixos/configuration.nix
        '';
        deps = [];

      };
    };
    system.userActivationScripts = {
      home = {
        text = ''
          mkdir -p ~/.config/nixpkgs
          ${pkgs.git}/bin/git clone git://github.com/fricklerhandwerk/.config.git
        '';
        deps = [];

      };
    };
  users.users.vg = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = "18.09";
}
