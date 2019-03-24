{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
    /etc/nixos/hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "x240";
  networking.wireless.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  # enable backlight keys
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = let step = "10"; in [
      { keys = [224]; events = ["key"]; # down
        command ="/run/wrappers/bin/light -U ${step}";
      }
      { keys = [225]; events = ["key"]; # up
        command ="/run/wrappers/bin/light -A ${step}";
      }
    ];
  };
}
