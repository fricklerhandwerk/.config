{ pkgs, ... }:
let
  src = fetchTarball {
    # NixOS 20.09 2021-01-13
    url = "https://github.com/NixOS/nixpkgs/archive/aa5b9cd16b91d8a24681c3888951d7c3dc612314.tar.gz";
    sha256 = "1cyz0xhsy8wa5bf1mh9cind3xvlf5wqz3k4dr9kdhd08wd978f6f";
  };
  nixos-20-09 = pkgs.callPackage src { config = pkgs.config; };
  wine = nixos-20-09.wineWowPackages.staging;
  winetricks = nixos-20-09.winetricks.override { inherit wine; };
in
{
  home.packages = [ wine winetricks ];
}
