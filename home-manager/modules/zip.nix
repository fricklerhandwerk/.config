{ pkgs, ... }:
with pkgs;
{
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    unzip
    gzip
    unrar
    p7zip
  ];
}
