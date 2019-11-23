{ pkgs, ... }:
let
  src = fetchGit {
    name = "nixpkgs-unstable";
    url = "https://github.com/NixOS/nixpkgs-channels";
    ref = "nixpkgs-unstable";
    # pin wine to some known-working release, using impure `unstable` will often
    # provoke lengthy recompilation
    rev = "f35f0880f2cdbc8c1bc81492811251f120d7a9bc";
  };
  unstable = pkgs.callPackage src { config = pkgs.config; };
  wine = unstable.wine.override { wineRelease = "unstable"; };
  winetricks = unstable.winetricks.override { wine = wine; };
in
{
  home.packages = [
    wine
    winetricks
  ];
}
