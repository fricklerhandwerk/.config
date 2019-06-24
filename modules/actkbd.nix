{ config, lib, pkgs, ... }:
with lib;
let
  # TODO: do not disable original actkbd, just add new fields if possible
  cfg = config.services.actkbd;

  configFile = bindings: pkgs.writeText "actkbd.conf" ''
    ${concatMapStringsSep "\n"
      ({ keys, events, attributes, command, ... }:
        ''${concatMapStringsSep "+" toString keys}:${concatStringsSep "," events}:${concatStringsSep "," attributes}:${command}''
      ) bindings}
    ${cfg.extraConfig}
  '';

  bindingCfg = { ... }: {
    options = {

      keys = mkOption {
        type = types.listOf types.int;
        description = "List of keycodes to match.";
      };

      events = mkOption {
        type = types.listOf (types.enum ["key" "rep" "rel"]);
        default = [ "key" ];
        description = "List of events to match.";
      };

      attributes = mkOption {
        type = types.listOf types.str;
        default = [ "exec" ];
        description = "List of attributes.";
      };

      command = mkOption {
        type = types.str;
        default = "";
        description = "What to run.";
      };

    };
  };

in

{
  imports = [ ../modules/device-wants.nix ];

  options = {

    services.actkbd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the <command>actkbd</command> key mapping daemon.

          Turning this on will start an <command>actkbd</command>
          instance for every evdev input that has at least one key
          (which is okay even for systems with tiny memory footprint,
          since actkbd normally uses &lt;100 bytes of memory per
          instance).

          This allows binding keys globally without the need for e.g.
          X11.
        '';
      };

      bindings = mkOption {
        type = types.listOf (types.submodule bindingCfg);
        default = [];
        example = lib.literalExample ''
          [ { keys = [224]; events = ["key"]; command ="/run/wrappers/bin/light -U -r 10"; } ]
        '';
        description = ''
          Key bindings for <command>actkbd</command>.

          See <command>actkbd</command> <filename>README</filename> for documentation.
        '';
      };

      user-bindings = mkOption {
        type = types.listOf (types.submodule bindingCfg);
        default = [];
        example = lib.literalExample ''
          [ { keys = [ 113 ]; events = [ "key" ]; command = "''${pkgs.pulsaudio-ctl}/bin/pulseaudio-ctl mute"; } ]
        '';
        description = ''
          Key bindings for <command>actkbd</command>.

          See <command>actkbd</command> <filename>README</filename> for documentation.

          The example shows a piece of what <option>sound.enableMediaKeys</option> should be like if it would actually work.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal contents to append to the end of actkbd configuration file.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "actkbd-udev-rules";
      destination = "/etc/udev/rules.d/61-actkbd.rules";
      text = ''
        ACTION=="add", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_KEY}=="1", TAG+="systemd", PROGRAM="${pkgs.systemd}/bin/systemd-escape --path --template=actkbd@.service $env{DEVNAME}", ENV{SYSTEMD_WANTS}+="%c", ENV{SYSTEMD_USER_WANTS}+="%c"
      '';
    });

    systemd.services."actkbd@" = {
      unitConfig = {
        Description = "actkbd (root) on %f";
        ConditionPathExists = "%f";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.actkbd}/bin/actkbd -D -c ${configFile cfg.bindings} -d %f";
      };
    };

    # to use `pulseaudio` with keypresses captured by `actkbd`, we must run
    # `actkbd` as the owner of the respective `pulseaudio` instance.
    systemd.user.services."actkbd@" = {
      unitConfig = {
        Description = "actkbd (%u) on %f";
        ConditionPathExists = "%f";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.actkbd}/bin/actkbd -D -c ${configFile cfg.user-bindings} -d %f";
      };
    };

    # For testing
    environment.systemPackages = [ pkgs.actkbd ];

  };
}

