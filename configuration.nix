{ config, pkgs,  ... }:
with builtins;
with pkgs;
let
  home-manager = import (
    fetchTarball https://github.com/rycee/home-manager/archive/release-18.09.tar.gz
    ) { inherit pkgs; };
  home-config = { config, lib, pkgs, utils, ... }:
    with lib;
    let
      users = config.home-config.users;
    in
    {
      options = {
        home-config.users = mkOption {
          description = "per-user home config repository";
          type = types.attrsOf (types.submodule {
            options = {
              repo = mkOption {
                type = types.str;
                description = "git repository with user configuration";
              };
            };
          });
        };
      };
      config = mkIf (users != {}) {
        systemd.services = mapAttrs' (username: cfg:
          nameValuePair ("home-config-${utils.escapeSystemdPath username}") {
            description = "initial home-manager configuration for ${username}";
            wantedBy = [ "multi-user.target" ];
            wants = [ "nix-daemon.socket" ];
            after = [ "nix-daemon.socket" ];
            serviceConfig = {
              User = username;
              Type = "oneshot";
              SyslogIdentifier = "home-config-${username}";
              ExecStart = pkgs.writeScript "home-config-${username}"
              ''
                #! ${pkgs.stdenv.shell} -el
                if [[ ! -d $HOME/.config ]]; then
                  cd $HOME
                  ${pkgs.git}/bin/git clone ${cfg.repo}
                  ${home-manager.home-manager}/bin/home-manager switch
                fi
              '';
            };
          }
        ) users;
      };
    };
in
{
  imports =
    [
      ./hardware-configuration.nix
      home-config
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
  home-config.users.vg.repo = https://github.com/fricklerhandwerk/.config;

  system.stateVersion = "18.09";
}
