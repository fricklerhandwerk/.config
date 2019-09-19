{ pkgs, ... }:
with pkgs;
# latest wine available
let wine = (unstable.wine.override { wineRelease = "unstable"; });
in
{
  home.packages = [
    wine
    (unstable.winetricks.override { wine = wine; })
  ];
}
