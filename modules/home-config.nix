{ config, lib, pkgs, utils,  ... }:
with lib;
with pkgs;
let
  # TODO: extend `config.users.users` to accomodate the new fields.
  users = config.home-config.users;
in
{
  options = {
    home-config.users = mkOption {
      description = "per-user home config repository";
      type = types.attrsOf (types.submodule {
        options = {
          repo = mkOption {
            type = types.str;
            description = "git repository with user configuration";
          };
          branch = mkOption {
            type = types.str;
            default = "master";
            description = "branch in repository to clone";
          };
          path = mkOption {
            type = types.str;
            default = ".config";
            description = "clone path for configuration repository, relative to user's $HOME"; };
          install = mkOption {
            type = types.str;
            default = "install";
            description = "executable in repository to run before login";
          };
        };
      });
    };
  };
  config = {
    # run get user configuration on startup
    systemd.services = mkIf (users != {}) (
      let
        initialise = user: "home-config-init-${utils.escapeSystemdPath user}";
        check = user: "home-config-check-${utils.escapeSystemdPath user}";
        service = unit: "${unit}.service";
        git = "${pkgs.git}/bin/git";
      in
      mapAttrs' (user: cfg: nameValuePair (check user) {
        description = "check home configuration for ${user}";
        wantedBy = [ "multi-user.target" ];
        onFailure = [ (service (initialise user)) ];
        serviceConfig = {
          User = user;
          Type = "oneshot";
          SyslogIdentifier = check user;
          ExecStart = writeScript (check user)
            ''
              #! ${stdenv.shell} -el
              mkdir -p $HOME/${cfg.path}
              cd $HOME/${cfg.path}
              ${git} init
              if ${git} remote add origin ${cfg.repo}
              # flip return code
              then
                echo home-config not initialised
                exit 128
              else
                exit 0
              fi
            '';
        };
      }) users //
      mapAttrs' (user: cfg: nameValuePair (initialise user) {
        description = "initialise home-manager configuration for ${user}";
        # do not allow login before setup is finished. after first boot the
        # process takes a long time, and the user would log into a broken
        # environment.
        # let display manager wait in graphical setups.
        before = [ "systemd-user-sessions.service" ] ++ optional config.services.xserver.enable "display-manager.service";
        # `nix-daemon` and `network-online` are required under the assumption
        # that installation performs `nix` operations and those usually need to
        # fetch remote data
        after = [ "nix-daemon.socket" "network-online.target" ];
        requires = [ "nix-daemon.socket" "network-online.target" ];
        serviceConfig = {
          User = user;
          Type = "oneshot";
          SyslogIdentifier = initialise user;
          ExecStart = writeScript (initialise user)
            ''
              #! ${stdenv.shell} -el
              cd $HOME/${cfg.path}
              ${git} fetch
              ${git} checkout ${cfg.branch} --force
              $HOME/${cfg.path}/${cfg.install}
            '';
        };
      }) users);

    # this is a user-specific requirement, but needs to be supported by the
    # system for fully-automatic bootstrapping *before* first login. not sure
    # what could be a good approach to deploying secrets except storing a PGP
    # private key locally (e.g. on a USB key) and mounting it for copying.
    # TODO: iterate over `users` and add permissions per user. there should be
    # a field in `home-config` to define a (list of) device(s) with certain
    # properties (such as file system UUID) and filter by those properties for
    # mounting.
    # polkit rule interface:
    # <https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html#polkit-rules>
    # udisks2 variables and actions:
    # <http://storaged.org/doc/udisks2-api/2.7.5/udisks-polkit-actions.html>
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        var permission = {
          "org.freedesktop.udisks2.filesystem-mount": "yes",
          "org.freedesktop.udisks2.filesystem-mount-other-seat": "yes",
        };
        if (subject.isInGroup("wheel")) {
          return permission[action.id];
        }
      });
    '';
  };
}
