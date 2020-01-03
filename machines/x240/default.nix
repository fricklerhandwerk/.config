{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/workstation/graphical
  ];

  machine = ./.;

}
