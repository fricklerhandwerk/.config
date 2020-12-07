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
    less
    coreutils
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
  xdg.enable = true;
}
