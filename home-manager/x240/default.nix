{ pkgs, ... }:
{
  imports = [
    ../nixos
  ];

  machine = ./.;

}
