# configuration for linux machines with human interface devices
{ pkgs, ... }:
{
  imports = [
    ../.
    ../../workstation
    ./secrets.nix
    ./ssh-agent.nix
  ];

  home.packages = let
    una = pkgs.writeScriptBin "una" (builtins.readFile ./una.fish);
  in [ una ];
}
