{ pkgs, ... }:
{
  imports = [
    ../terminal
    ./fix-time-machine.nix
  ];

  home.packages = with pkgs; [
    # TODO: set up proper configuration
    kitty
    umlet
  ];
}
