{ config, pkgs, ... }:
with pkgs;
let
  home-manager = callPackage ./modules/home-manager.nix {};
in
{
  imports = [
    ./modules/unstable.nix
    ./modules/machine.nix
  ];

  nixpkgs.overlays = [ (self: super: {home-manager = home-manager.pkg; }) ];

  home.packages = [
    (home-manager.wrapper {path = config.machine; })
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
