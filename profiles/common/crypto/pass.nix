{ config, pkgs, ... }:
{
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    PASSWORD_STORE_CLIP_TIME = 30;
  };
  home.packages = with pkgs; [
    pass
  ];
}

