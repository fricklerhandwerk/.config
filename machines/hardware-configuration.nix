# FIXME: little hack to ease bootstrapping.
# since system and user configuration live in the same repository, on
# installtion we clone that to `/root`, and the installer just overwrites this
# file - it only lives in memory. when the system is running, the user home
# gets cloned again, but hardware-configuration is already persisted in
# `/etc/nixos/`.
# the weirdness of the process reminds us taht system and user configuration
# should really live in different repositories.
{ config, pkgs, lib, ... }:
{
  imports = [ /etc/nixos/hardware-configuration.nix ];
}
