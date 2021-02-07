{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./machine.nix
    ./nixops.nix
    ./nvim
    ./unstable.nix
    ./zip.nix
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
