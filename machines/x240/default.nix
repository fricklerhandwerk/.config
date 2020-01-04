{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/terminal
    ../../modules/linux/graphical
  ];

  machine = ./.;
}
