{ config, pkgs, ... }:
{
  home.sessionVariables = {
    # TODO: `GNUPGHOME` is not configurable yet, see
    # <https://github.com/rycee/home-manager/pull/887>
    GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
  };
  home.packages = with pkgs; [
    gnupg
  ];
  services.gpg-agent.enable = pkgs.stdenv.isLinux;
}
