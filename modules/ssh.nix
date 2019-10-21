{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
