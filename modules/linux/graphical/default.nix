{ pkgs, ... }:
{
  imports = [
    ../.
    ./dunst.nix
    ./xmonad.nix
    ./wine.nix
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
  # auto-mount external storage
  services.udiskie.enable = true;
}
