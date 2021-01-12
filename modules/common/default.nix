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
    fd
    htop
    ranger
    less
    coreutils
    rsync
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
  };
  xdg.enable = true;
}
