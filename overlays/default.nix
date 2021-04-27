{ pkgs, ... }:
let
  unstable = import ./unstable.nix;
  home-manager = self: super: {
   home-manager = pkgs.callPackage ./home-manager.nix;
  };
  nixops = import ./nixops.nix;
  tor-browser = import ./tor-browser.nix;
  wine = import ./wine.nix;
in
{
  nixpkgs.overlays = [
    unstable
    home-manager
    nixops
    tor-browser
    wine
  ];
}
