{ pkgs, ... }:
{
  home.packages = [
    pkgs.htop
    pkgs.git
  ];
}
