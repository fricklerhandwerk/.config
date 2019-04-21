{ pkgs, ... }:
with builtins;
{
  imports = [
    ./secrets.nix
    ./xmonad.nix
  ];
  home.packages = with pkgs; [
    qutebrowser
  ];
}
