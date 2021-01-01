{ pkgs, ... }:
{
  imports = [
    ../terminal
    ./fix-time-machine.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  home.packages = with pkgs; [
    # TODO: set up proper configuration
    kitty
    umlet
    (pkgs.callPackage ./nixos-rebuild.nix {})
  ];

  programs.fish = {
    shellInit = ''
      set -x PATH ~/.nix-profile/bin $PATH
      set -x NIX_PATH ~/.nix-defexpr/channels
      # this is a workaround to source the nix profile, which written in `sh`.
      # see: # <https://github.com/nix-community/home-manager/blob/7e5fee4268f53be8758598b7634dff8b3ad8a22b/modules/programs/fish.nix#L346>
      # I would have liked to just add the `foreign-env` plugin to `fish`, but
      # this not only introduces bootstrapping questions, but is also
      # impossible in `home-manager` 19.09 since that module option is not yet
      # available there.
      set -p fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions
      fenv source ~/.nix-profile/etc/profile.d/nix.sh
set -e fish_function_path[1]
    '';
  };
}
