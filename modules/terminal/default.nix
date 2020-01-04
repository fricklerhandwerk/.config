{ pkgs, ... }:
{
  imports = [
    ../common
    ./pass.nix
    ./gpg.nix
    ./ssh.nix
  ];
}
