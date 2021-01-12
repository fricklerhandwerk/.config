{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/terminal
    ../../modules/linux/graphical
  ];

  machine = ./.;

  xdg.configFile."xmobar/xmobarrc".source = ./xmobarrc;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    unstable.steam
    unstable.teamspeak_client
  ];
}
