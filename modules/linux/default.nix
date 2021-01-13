{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  home.packages = with pkgs; [
    # convenient interface to manually manage external storage
    udiskie
    acpi
    cifs-utils
    fuseiso
  ];
}
