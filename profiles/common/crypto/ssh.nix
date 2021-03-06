{ config, pkgs, ... }:
let
  ssh = "${config.home.homeDirectory}/.ssh";
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github github.com" = {
        hostname = "github.com";
        identityFile = "${ssh}/github";
      };
      una = {
        forwardAgent = true;
        hostname = "una.local";
        identityFile = "${ssh}/una";
      };
      webgo = {
        user = "web196";
        hostname = "server18.webgo24.de";
        identityFile = "${ssh}/webgo";
      };
      ghost = {
        forwardAgent = true;
        hostname = "89.144.19.124";
        identityFile = "${ssh}/ghost";
      };
      rip = {
        forwardAgent = true;
        hostname = "85.93.16.234";
        identityFile = "${ssh}/rip";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
