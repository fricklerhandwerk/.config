{ pkgs, ... }:
{
  imports = [
    ../../common/crypto
    ./secrets.nix
    ./ssh-agent.nix
  ];
}
