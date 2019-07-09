{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.actkbd;

  configFile = pkgs.writeText "actkbd.conf" ''
    ${concatMapStringsSep "\n"
      ({ keys, events, attributes, command, ... }:
        ''${concatMapStringsSep "+" toString keys}:${concatStringsSep "," events}:${concatStringsSep "," attributes}:${command}''
      ) cfg.user.bindings}
    ${cfg.user.extraConfig}
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
  # make udev rules trigger user services
  imports = [ ../modules/device-wants.nix ];

  options = {

    services.actkbd.user = {

      bindings = mkOption {
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

  config = mkIf (cfg.enable && cfg.user.bindings != []) {

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "actkbd-udev-user-rules";
      destination = "/etc/udev/rules.d/61-actkbd-user.rules";
      text = ''
        ACTION=="add", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ENV{ID_INPUT_KEY}=="1", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="actkbd@$env{DEVNAME}.service"
      '';
    });

    # to use `pulseaudio` with keypresses captured by `actkbd`, we must run
    # `actkbd` as the owner of the respective `pulseaudio` instance.
    systemd.user.services."actkbd@" = {
      unitConfig = {
        Description = "actkbd on %I";
        ConditionPathExists = "%I";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.actkbd}/bin/actkbd -D -c ${configFile} -d %I";
      };
    };
  };
}

