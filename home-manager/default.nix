{ pkgs, ... }:
with builtins;
{
  home.packages = with pkgs; [
    git
    neovim
    htop
    qutebrowser
    ranger
    vlc
  ];
  programs.fish.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
