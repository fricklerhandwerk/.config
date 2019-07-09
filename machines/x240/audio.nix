{ config, pkgs,  ... }:
with config;
{
  imports = [ ../../modules/actkbd.nix ];

  hardware.pulseaudio.enable = true;
  environment.systemPackages = [ pkgs.pulseaudio-ctl ];
  services.actkbd = {
    enable = true;
    user.bindings = let audio = "${pkgs.pulseaudio-ctl}/bin/pulseaudio-ctl"; in [
      { keys = [113]; events = ["key"]; command = "${audio} mute"; }
      { keys = [114]; events = ["key"]; command = "${audio} mute no && ${audio} down"; }
      { keys = [115]; events = ["key"]; command = "${audio} mute no && ${audio} up"; }
      { keys = [190]; events = ["key"]; command = "${audio} mute-input"; }
    ];
  };
}
