{ system ? "x86_64-linux" }:
let
  nixpkgs = builtins.fetchGit {
    name = "nixpkgs";
    url = "https://github.com/NixOS/nixpkgs";
    # a version where `NetworkManager-wait-online.service` works,
    # see <ec83b8ccc11de36007ac418e2425f96e2db4018a>
    ref = "release-18.09";
    rev = "0d84ab811e216d0711fb2afae7b0a96e78299fca";
  };
  config = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
    environment.systemPackages = with pkgs; [ neovim ];
  };

  eval = configuration: import "${nixpkgs}/nixos" {
    inherit system configuration;
  };
in {
  iso = (eval config).config.system.build.isoImage;
}
