{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github github.com" = {
        hostname = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
      "fricklerhandwerk fricklerhandwerk.de" = {
        hostname = "fricklerhandwerk.de";
        identityFile = "${config.home.homeDirectory}/.ssh/una";
      };
      webgo = {
        user = "web196";
        hostname = "server18.webgo24.de";
        identityFile = "${config.home.homeDirectory}/.ssh/una";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
