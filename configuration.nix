{ config, pkgs, ... }:
  let home-manager = pkgs.home-manager.overrideAttrs ( oldAttrs:{
    src = pkgs.fetchFromGitHub {
      owner = "fricklerhandwerk";
      repo = "home-manager";
      rev = "aeebcdf04a5041834c6b07ccd917b446f9bac32a";
      sha256 = "0nbknnc1jbdicq5pangxvzf8gqb90h2kd9yj610j0sbxdwccn5d3c";
    };
    buildCommand = ''
      install -v -D -m755 ${home-manager.src}/home-manager/home-manager $out/bin/home-manager
      substituteInPlace $out/bin/home-manager \
        --subst-var-by bash "${pkgs.bash}" \
        --subst-var-by coreutils "${pkgs.coreutils}" \
        --subst-var-by findutils "${pkgs.findutils}" \
        --subst-var-by gnused "${pkgs.gnused}" \
        --subst-var-by less "${pkgs.less}" \
        --subst-var-by nix "${pkgs.nix}" \
        --subst-var-by HOME_MANAGER_PATH '${home-manager.src}'
     '';
   }); in
{
  imports =
    [
      ./hardware-configuration.nix
    ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.wireless.enable = true;

    time.timeZone = "Europe/Berlin";

    environment.systemPackages = with pkgs; [
      neovim
      home-manager
    ];

    # TODO: run this only for specific user
    system.userActivationScripts = {
      home = {
        text = ''
          # assuming absence of `~/.config` is equivalent to a fresh install,
          # fetch user config from remote repository
          if [[ ! -d ~/.config ]]; then
            ${pkgs.git}/bin/git clone git://github.com/fricklerhandwerk/.config.git
            ${home-manager}/bin/home-manager switch
          fi
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
