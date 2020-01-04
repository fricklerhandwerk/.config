{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/terminal
  ];

  machine = ./.;
}
