{ pkgs, ... }:
{
  imports = [
    ../.
    ../../terminal
    ./secrets.nix
    ./ssh-agent.nix
  ];

  home.packages = let
    una = pkgs.writeScriptBin "una" (builtins.readFile ./una.fish);
  in [ una ];
}
