{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/id_rsa_github";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
