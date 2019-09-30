{ ... }:
let
  src = fetchGit {
    name = "nixpkgs-unstable";
    url = "https://github.com/NixOS/nixpkgs-channels";
    ref = "nixpkgs-unstable";
  };
  overlay = self: super: {
    unstable = super.callPackage src { config = super.config; };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}

