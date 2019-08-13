{ pkgs, ... }:
{
  imports = [
    ./unstable.nix
    ./home-manager.nix
  ];

  home.packages = with pkgs; [
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
