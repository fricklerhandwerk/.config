# common configuration for all machines
{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./machine.nix
    ./nvim
    ./zip.nix
    ./unstable.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    htop
    ranger
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  xdg.enable = true;
}
