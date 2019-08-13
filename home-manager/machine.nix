{ lib, ... }:
with lib;
{
  options = {
    machine = mkOption {
      type = types.path;
      description = "machine to use with `home-manager` wrapper";
    };
  };
}
