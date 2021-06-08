{ pkgs, ... }:
{
  imports = [
    ../../profiles/linux
    ./smbc.nix
  ];

  machine = ./.;
}
