{ config, pkgs, ... }:
let
  env = config.home.sessionVariables;
in
{
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${env.XDG_DATA_HOME}/password-store";
    PASSWORD_STORE_CLIP_TIME = 30;
  };
  home.packages = with pkgs; [
    pass
  ];
}

