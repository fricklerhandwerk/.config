{ config, pkgs, lib, ... }:
with lib;
with pkgs;
let
  src = builtins.fetchGit {
    name = "home-manager-18.09";
    url = https://github.com/rycee/home-manager;
    ref = "release-18.09";
  };
  overlay = self: super: {
    home-manager = (callPackage src {}).home-manager;
  };
  wrapper = path: (symlinkJoin {
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
    nixpkgs.overlays = [ overlay ];
    home.packages = [ (wrapper (toString config.machine)) ];
  };
}
