{ pkgs, ... }:
{
  imports = [
    ../../modules/linux/terminal
    ../../modules/linux/graphical
  ];

  machine = ./.;

  xdg.configFile."xmobar/xmobarrc".source = ./xmobarrc;

  home.packages = with pkgs; [
    unstable.steam
    unstable.teamspeak_client
  ];
}
