{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  src = builtins.fetchGit {
    name = "home-manager-19.03";
    url = https://github.com/rycee/home-manager;
    ref = "release-19.03";
  };
in
callPackage "${src}/home-manager" { path = "${src}"; }
