{ config, pkgs,  ... }:
{
  disabledModules = [ "services/hardware/actkbd.nix" ];
  imports = [
    ../default.nix
    ../actkbd.nix
    /etc/nixos/hardware-configuration.nix
    <nixos-hardware/lenovo/thinkpad/x250>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "x240";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
  };
  i18n.consoleUseXkbConfig = true;

  # enable backlight keys
  programs.light.enable = true;
  # enable media keys
  hardware.pulseaudio.enable = true;
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
    user-bindings = let audio = "${pkgs.pulseaudio-ctl}/bin/pulseaudio-ctl"; in [
      { keys = [113]; events = ["key"]; command = "${audio} mute"; }
      { keys = [114]; events = ["key"]; command = "${audio} mute no && ${audio} down"; }
      { keys = [115]; events = ["key"]; command = "${audio} mute no && ${audio} up"; }
      { keys = [190]; events = ["key"]; command = "${audio} mute-input"; }
    ];
  };
}
