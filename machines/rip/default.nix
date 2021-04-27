{ pkgs, ... }:
{
  imports = [
    ../../profiles/common
  ];

  machine = ./.;
}
