{ pkgs, ... }:
{
  imports = [
    ../terminal
    ./fix-time-machine.nix
  ];

  home.packages = with pkgs; [
    # TODO: set up proper configuration
    kitty
    umlet
  ];

  programs.fish = {
    shellInit = ''
      set -x PATH ~/.nix-profile/bin $PATH
      set -x NIX_PATH ~/.nix-defexpr/channels
    '';
  };
}
