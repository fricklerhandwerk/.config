{ pkgs, ... }:
{
  imports = [
    ../../modules/linux
  ];

  machine = ./.;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    unstable.steam
    unstable.teamspeak_client
  ];
}
