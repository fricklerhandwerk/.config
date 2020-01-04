{ pkgs, ... }:
{
  imports = [
    ../common
  ];

  # auto-mount external storage
  services.udiskie.enable = true;
  home.packages = with pkgs; [
    udiskie # manually manage external storage
    acpi
  ];
}
