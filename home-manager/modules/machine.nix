# machine-specific wrapper to `home-manager`, such that `home-manager switch`
# automatically uses the correct configuration files
{ config, pkgs, lib, ... }:
with pkgs;
with lib;
let
  home-manager = callPackage ./home-manager.nix {};
  wrapper = {path}: (symlinkJoin {
    name = "home-manager";
    paths = [
      (writeShellScriptBin "home-manager" ''
        exec ${home-manager}/bin/home-manager -f ${toString path} $@
       '')
      home-manager
    ];
  });
in
{
  options = {
    machine = mkOption {
      type = types.path;
      description = "machine to use with `home-manager` wrapper";
    };
  };
  config = {
    home.packages = [ (wrapper { path = config.machine; }) ];
  };
}
