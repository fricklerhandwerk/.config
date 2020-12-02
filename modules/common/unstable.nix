{ ... }:
let
  src = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  overlay = self: super: {
    unstable = super.callPackage src { config = super.config; };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}

