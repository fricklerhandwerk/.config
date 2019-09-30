{ pkgs, ...}:
let
  una = pkgs.writeScriptBin "una" (builtins.readFile ./una.fish);
in
{
  home.packages = [ una ];
}
