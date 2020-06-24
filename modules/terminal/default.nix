{ pkgs, ... }:
{
  imports = [
    ../common
    ./pass.nix
    ./gpg.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    unstable.youtube-dl
  ];
}
