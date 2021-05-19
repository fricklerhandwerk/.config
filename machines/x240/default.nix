{ pkgs, ... }:
{
  imports = [
    ../../profiles/linux
    ../../profiles/linux/crypto
    ../../profiles/linux/graphical
  ];

  machine = ./.;
  home.packages = [
    ((pkgs.freeciv.override {gtkClient = true;}).overrideAttrs (old: {
      configureFlags = [ "--enable-client=gtk" ];
    }))
  ];
}
