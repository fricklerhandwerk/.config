{ pkgs, ... }:
{
  imports = [
    ../../profiles/linux
    ../../profiles/linux/crypto
    ../../profiles/linux/graphical
  ];

  machine = ./.;
}
