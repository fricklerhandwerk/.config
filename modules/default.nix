{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./machine.nix
    ./nvim
    ./pass.nix
    ./ssh.nix
    ./unstable.nix
    ./zip.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    htop
    ranger
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
