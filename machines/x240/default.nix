{ pkgs, ... }:
{
  imports = [
    ../../modules/linux
  ];

  machine = ./.;

}
