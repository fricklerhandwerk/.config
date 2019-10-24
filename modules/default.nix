{ pkgs, ... }:
{
  imports = [
    ./unstable.nix
    ./machine.nix
    ./nvim
    ./fish.nix
    ./ssh.nix
    ./git.nix
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
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
