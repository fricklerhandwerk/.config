{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
      fricklerhandwerk = {
        host = "fricklerhandwerk.de";
        identityFile = "${config.home.homeDirectory}/.ssh/una";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
