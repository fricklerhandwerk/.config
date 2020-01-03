# configuration for linux machines with graphical user interface
{ pkgs, ... }:
{
  imports = [
    ../.
    ./dunst.nix
    ./xmonad.nix
  ];

  home.packages = with pkgs;
  let
    tor-browser = unstable.tor-browser-bundle-bin.override
      { mediaSupport = true; };
  in [
    qutebrowser
    vlc
    tor-browser
  ];
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };
}
