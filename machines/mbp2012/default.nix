{ pkgs, ... }:
{
  imports = [
    ../../profiles/darwin
  ];

  machine = ./.;
}
