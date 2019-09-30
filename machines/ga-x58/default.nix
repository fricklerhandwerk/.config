{ config, pkgs,  ... }:
{
  imports = [
    ../default.nix
  ];

  boot = {
    plymouth.enable = true;
    loader = {
      grub = {
        device = "/dev/disk/by-id/ata-OCZ-ONYX_273K6Q20DXA22LRV81C5";
        # an image is drawn even if the menu is skipped
        splashImage = null;
        extraConfig = ''
          if keystatus ; then
            if keystatus --alt ; then
              set timeout=-1
            else
              set timeout=0
            fi
          fi
        '';
      };
    };
  };


  networking.hostName = "ga-x58";
  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkbOptions = "altwin:swap_lalt_lwin";
    videoDriver = "nvidiaLegacy390";
  };
  i18n.consoleUseXkbConfig = true;

  # use closed-source drivers
  nixpkgs.config.allowUnfree = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
}
