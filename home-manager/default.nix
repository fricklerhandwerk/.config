{ config, pkgs, ... }:
with pkgs;
{
  imports = [
    ./modules/unstable.nix
    ./modules/machine.nix
    ./modules/git.nix
  ];

  home.packages = [
    ripgrep
    git
    neovim
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
