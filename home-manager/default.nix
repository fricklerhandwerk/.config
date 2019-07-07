{ pkgs, ... }:
with builtins;
let
  unstable = let
    nixpkgs-unstable = fetchGit {
      name = "nixpkgs-unstable";
      url = "https://github.com/NixOS/nixpkgs-channels";
      ref = "nixpkgs-unstable";
    };
    in import nixpkgs-unstable { config = pkgs.config; };
in
{
  home.packages = with pkgs; [
    git
    neovim
    htop
    qutebrowser
    ranger
    vlc
    unstable.tor-browser-bundle-bin
  ];
  programs.fish.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
