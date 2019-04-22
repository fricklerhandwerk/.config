{ pkgs, ... }:
with builtins;
{
  imports = [
    ./secrets.nix
    ./xmonad
  ];
  home.packages = with pkgs; [
    qutebrowser
  ];
}
