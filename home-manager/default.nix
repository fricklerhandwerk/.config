{ config, pkgs, ... }:
with pkgs;
{
  imports = [
    ./modules/unstable.nix
    ./modules/machine.nix
    ./modules/nvim
    ./modules/fish.nix
    ./modules/ssh.nix
    ./modules/git.nix
    ./modules/wine.nix
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
