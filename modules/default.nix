{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./machine.nix
    ./nvim
    ./pass.nix
    ./ssh.nix
    ./unstable.nix
    ./wine.nix
    ./zip.nix
  ];

  home.packages = with pkgs;
  let
    tor-browser = unstable.tor-browser-bundle-bin.override
      { mediaSupport = true; };
  in [
    ripgrep
    git
    gitAndTools.hub
    htop
    qutebrowser
    ranger
    vlc
    tor-browser
  ];
  home.sessionVariables =
  let
    home = config.home.homeDirectory;
  in
  {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "${home}/.config";
    XDG_DATA_HOME = "${home}/.local/share";
  };
}
