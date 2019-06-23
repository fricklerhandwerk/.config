{ pkgs, ... }:
{
  # auto-mount external storage
  services.udiskie.enable = true;
  # manually manage external storage if needed
  home.packages = [ pkgs.udiskie ];
}
