let
  src = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
self: super: {
  unstable = super.callPackage src { config = super.config; };
}
