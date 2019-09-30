{ config, pkgs,  ... }:
let
  thinkpad-x240 = let
    src = builtins.fetchGit {
      url = https://github.com/NixOS/nixos-hardware;
      ref = "master";
    };
  # there is no extra definition for x240
  in "${src}/lenovo/thinkpad/x250";
in
{
  imports = [
    ../default.nix
    thinkpad-x240
    ./audio.nix
    ./backlight.nix
  ];

  networking.hostName = "x240";
  time.timeZone = "Europe/Berlin";

  boot = {
    plymouth.enable = true;
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
        extraConfig = ''
          set timeout_style=hidden
        '';
        # an image is drawn even if the menu is skipped
        splashImage = null;
      };
    };
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;
  hardware.opengl.driSupport32Bit = true;
}
