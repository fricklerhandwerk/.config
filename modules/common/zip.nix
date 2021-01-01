{ pkgs, ... }:
with pkgs;
{
  home.packages = [
    unzip
    gzip
    unrar
    p7zip
  ];
}
