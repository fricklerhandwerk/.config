{ system ? "x86_64-linux" }:
let
  nixpkgs = builtins.fetchGit {
    name = "nixpkgs";
    url = "https://github.com/NixOS/nixpkgs";
    ref = "release-19.03";
    rev = "520c39049f585c05f216bc12c088e4f5fd988d73";
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
