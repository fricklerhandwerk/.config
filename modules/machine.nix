# machine-specific wrapper to `home-manager`, such that `home-manager switch`
# automatically uses the correct configuration files
{ config, pkgs, lib, ... }:
with pkgs;
with lib;
let
  home-manager = writeShellScriptBin "home-manager" ''
    exec ${callPackage ./home-manager.nix {}}/bin/home-manager -f ${toString config.machine} $@
  '';
in
{
  options = {
    machine = mkOption {
      type = types.path;
      description = "machine to use with `home-manager` wrapper";
    };
  };
  config = {
    home.packages = [ home-manager ];
  };
}
