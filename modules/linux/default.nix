{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    # convenient interface to manually manage external storage
    udiskie
    acpi
    cifs-utils
    fuseiso
    logmein-hamachi
  ];
}
