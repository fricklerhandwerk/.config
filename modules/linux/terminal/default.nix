{ pkgs, ... }:
{
  imports = [
    ../.
    ../../terminal
    ./secrets.nix
    ./ssh-agent.nix
  ];
}
