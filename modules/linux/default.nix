# configuration for linux machines
{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  # auto-mount external storage
  services.udiskie.enable = true;
  home.packages = with pkgs; [
    acpi
    # manually manage external storage if needed
    udiskie
  ];
}
