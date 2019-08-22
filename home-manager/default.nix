{ config, pkgs, ... }:
with pkgs;
{
  imports = [
    ./modules/unstable.nix
    ./modules/machine.nix
    ./modules/nvim
    ./modules/fish.nix
    ./modules/git.nix
  ];

  home.packages = [
    ripgrep
    git
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
