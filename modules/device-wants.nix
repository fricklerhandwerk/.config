{ config, lib, pkgs, ... }:
{
  config = {
    systemd.user.services.udev-system-user-wants = {
      unitConfig = {
        Description = "udev ENV{SYSTEMD_USER_WANTS} units";
        Documentation = "file://${pkgs.writeText "doc" ''
          Start all ENV{SYSTEMD_USER_WANTS} units from udev.
          This is a workaround to let udev rules properly trigger user services.
        ''}";
      };
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = with pkgs; writeScript "get-systemd_user_wants" ''
          #! ${stdenv.shell} -el
          PATH=${buildPackages.udev}/bin:$PATH
          PATH=${coreutils}/bin:$PATH
          PATH=${findutils}/bin:$PATH
          PATH=${systemd}/bin:$PATH

          udevadm info -e | \
          grep '^E: SYSTEMD_USER_WANTS=' | \
          cut -d= -f2- | \
          xargs -d'\n' -n1 -r -t systemctl --user start
        '';
      };
    };
  };
}
