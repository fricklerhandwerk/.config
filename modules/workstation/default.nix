# configuration for machines with human interface devices
{ ... }:
{
  imports = [
    ../common
    ./pass.nix
    ./gpg.nix
    ./ssh.nix
  ];
}
