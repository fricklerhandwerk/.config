{ pkgs, lib, ... }:
let
  path = pkgs.path + /nixos/modules/installer/tools;
  fallback = import (path + /nix-fallback-paths.nix);
  debug = pkgs.writeText "debug.sed" ''
    5iexport PS4='\\033[0;33m+(''${BASH_SOURCE}:''${LINENO}):\\033[0m ''${FUNCNAME[0]:+''${FUNCNAME[0]}(): }'
  '';
  patch = pkgs.writeText "nixos-rebuild.nix" ''
    with import <nixpkgs/nixos> {};
    config.system.build.nixos-rebuild.overrideAttrs (old:
      {
          postInstall = ''\'''\'
            sed -i 's/^extraBuildFlags=.*$/extraBuildFlags=(--argstr system x86_64-linux)/' $out/bin/nixos-rebuild
            sed -i '5iset -x' $out/bin/nixos-rebuild
          sed -i -f ${debug} $out/bin/nixos-rebuild
          ''\'''\';
      })
    '';
  nixos-rebuild = (pkgs.substituteAll {
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
        substituteInPlace $out/bin/nixos-rebuild \
          --replace "--expr 'with import <nixpkgs/nixos> {}; config.system.build.nixos-rebuild'" "${patch}"
        sed -i '5iset -x' $out/bin/nixos-rebuild
        sed -i -f ${debug} $out/bin/nixos-rebuild
      '';
    });
in
{
  home.packages = [ nixos-rebuild ];
}
