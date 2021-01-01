{ pkgs, ... }:
{
  imports = [
    ../../modules/common
  ];

  machine = ./.;
}
