{ pkgs, lib, ... }:
let
  path = pkgs.path + /nixos/modules/installer/tools;
  fallback = import (path + /nix-fallback-paths.nix);
in
(pkgs.substituteAll {
  dir = "bin";
  isExecutable = true;
  name = "nixos-rebuild";
  src =  path + /nixos-rebuild.sh;
  inherit (pkgs) runtimeShell;
  nix = pkgs.nix.out;
  nix_x86_64_linux = fallback.x86_64-linux;
  nix_i686_linux = fallback.i686-linux;
  path = lib.makeBinPath [ pkgs.jq ];
}).overrideAttrs (old: {
  postInstall = ''
    # use a patched version of the target configuration's `nixos-rebuild`
    # that will work from Darwin
    substituteInPlace $out/bin/nixos-rebuild \
      --replace "--expr 'with import <nixpkgs/nixos> {}; config.system.build.nixos-rebuild'" "${./nixos-rebuild-patch.nix}"
  '';
})
