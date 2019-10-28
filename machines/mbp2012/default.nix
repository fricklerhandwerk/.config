{ pkgs, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  machine = ./.;
}
