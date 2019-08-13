{ pkgs, ... }:
{
  imports = [
    ../nixos
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    unstable.steam
    unstable.teamspeak_client
  ];
}
