{ pkgs }:
let
  # figure out `nixpkgs` release, since `home-manager` requires matching
  # releases for compatibility
  version = (import (pkgs.path + /nixos) {
    configuration = {};
  }).config.system.nixos.release;
  src = builtins.fetchGit {
    name = "home-manager-${version}";
    url = https://github.com/rycee/home-manager;
    ref = "release-${version}";
  };
in
pkgs.callPackage "${src}/home-manager" { path = "${src}"; }
