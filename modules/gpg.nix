{ config, pkgs, ... }:
{
  home.sessionVariables = {
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };
  home.packages = with pkgs; [
    gnupg
  ];
  services.gpg-agent.enable = true;
}
