{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/workstation/graphical
  ];

  machine = ./.;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    unstable.steam
    unstable.teamspeak_client
  ];
}
