{ config, pkgs, ... }:
with pkgs;
{
  imports = [
    ./unstable.nix
    ./machine.nix
    ./nvim
    ./fish.nix
    ./ssh.nix
    ./git.nix
    ./wine.nix
    ./zip.nix
  ];

  home.packages = [
    ripgrep
    git
    gitAndTools.hub
    htop
    qutebrowser
    ranger
    vlc
    (unstable.tor-browser-bundle-bin.override { mediaSupport = true; })
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
