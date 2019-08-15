{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  src = builtins.fetchGit {
    name = "home-manager-18.09";
    url = https://github.com/rycee/home-manager;
    ref = "release-18.09";
  };
in
callPackage "${src}/home-manager" { path = "${src}"; }
