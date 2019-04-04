{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
    /etc/nixos/hardware-configuration.nix
    <nixos-hardware/lenovo/thinkpad/x250>
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
    bindings = let step = "85"; light = "/run/wrappers/bin/light -r"; in [
      { keys = [224]; events = ["key"]; command = "${light} -U ${step}"; }
      { keys = [225]; events = ["key"];
        command = "${pkgs.writeScript "brightness-up" ''
          if [[ $(${light} -G) -eq "0" ]]; then
            ${light} -S 1
          else
            ${light} -A ${step}
          fi
        ''}";
      }
    ];
  };
}
