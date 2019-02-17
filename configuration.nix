{ config, pkgs,  ... }:
with builtins;
with pkgs;
let
  hmsrc = fetchTarball https://github.com/rycee/home-manager/archive/release-18.09.tar.gz;
  home-manager = import "${hmsrc}/home-manager" {inherit pkgs;};
  # TODO: declare `config` option for `config.users.users.{user}` to define
  # this where it belongs
  vg-config = fetchGit {
    url = "https://github.com/fricklerhandwerk/.config";
    ref = "master";
  };
  # TODO: if this step is done in a user service on login, fallback frequency
  # will still be good enough, but more importantly we can skip the initial
  # manual call to `home-manager` currently required to get the config into
  # user's `$HOME`
  user-home-manager = config: writeShellScriptBin "home-manager" ''
    if [[ ! -d "$HOME/.config" ]]; then
      cp -r "${config}" "$HOME/.config"
    fi
    exec "${home-manager}" -I home-manager=${hmsrc} $@
  '';
in
{
  imports =
    [
      ./hardware-configuration.nix
      "${hmsrc}/nixos"
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
    packages = [
      (symlinkJoin {
        name = "home-manager";
        paths = [
          (user-home-manager vg-config)
          home-manager
        ];
      })
    ];
  };
  # this creates or activates the most recent profile on login, which means
  # that later changes to the profile by the will not be overridden by a system
  # rebuild
  home-manager.users.vg = import "${vg-config}/nixpkgs/home.nix";

  system.stateVersion = "18.09";
}
