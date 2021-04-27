{ pkgs, ... }:
{
  imports = [
    ./pass.nix
    ./gpg.nix
    ./ssh.nix
  ];
}
