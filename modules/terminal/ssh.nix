{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        hostname = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
      fricklerhandwerk = {
        hostname = "fricklerhandwerk.de";
        identityFile = "${config.home.homeDirectory}/.ssh/una";
      };
      rip = {
        hostname = "89.144.19.17";
        identityFile = "${config.home.homeDirectory}/.ssh/una";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
