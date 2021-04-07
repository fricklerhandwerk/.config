{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./machine.nix
    ./nixops.nix
    ./nvim
    ./unstable.nix
    ./zip.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".text = pkgs.lib.generators.toPretty {} config.nixpkgs.config;

  home.packages = with pkgs; [
    coreutils
    fd
    gnused
    htop
    less
    ranger
    ripgrep
    rsync
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
  xdg.enable = true;
}
