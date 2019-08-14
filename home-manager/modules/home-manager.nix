{ pkgs ? import <nixpkgs> {} }:
with pkgs;
rec {
  src = builtins.fetchGit {
    name = "home-manager-18.09";
    url = https://github.com/rycee/home-manager;
    ref = "release-18.09";
  };
  pkg = callPackage "${src}/home-manager" { path = "${src}"; };
  wrapper = {path}: (symlinkJoin {
    name = "home-manager";
    paths = [
      (writeShellScriptBin "home-manager" ''
        exec ${pkg}/bin/home-manager -f ${toString path} $@
       '')
      pkg
    ];
  });
  env = mkShell { buildInputs = [ pkg ]; };
}
