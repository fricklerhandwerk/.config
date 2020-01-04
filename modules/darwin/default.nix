{ pkgs, ... }:
{
  imports = [
    ../terminal
  ];

  home.packages = with pkgs; [
    # TODO: set up proper configuration
    kitty
  ];
}
