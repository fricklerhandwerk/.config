{ pkgs, ... }:
{
  imports = [
    ../../profiles/linux
  ];

  machine = ./.;
}
