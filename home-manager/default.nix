{ config, pkgs, ... }:
with pkgs;
{
  imports = [
    ./modules/unstable.nix
    ./modules/machine.nix
    ./modules/git.nix
    ./modules/nvim
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
  programs.fish.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
