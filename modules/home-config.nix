{ config, lib, pkgs, utils,  ... }:
with lib;
with pkgs;
let
  # TODO: extend `config.users.users` to accomodate the new fields.
  users = config.home-config.users;
  home-manager-src = builtins.fetchGit {
    name = "home-manager-${config.system.stateVersion}";
    url = https://github.com/rycee/home-manager;
    ref = "release-${config.system.stateVersion}";
  };
  home-manager-overlay = self: super: {
    home-manager = (callPackage "${home-manager-src}/home-manager" {
      path = "${home-manager-src}";
    });
  };
  # TODO: do not install `home-manager` per user, let users manage that
  # themselves. then user config will be more portable, as it has to be
  # self-contained to be convenient to get going (required for macOS).
  home-manager-for-user = cfg: (symlinkJoin {
    name = "home-manager";
    paths = [
      (writeShellScriptBin "home-manager" ''
        exec ${home-manager}/bin/home-manager -f $HOME/${cfg.path}/${cfg.file} $@
       '')
      home-manager
    ];
  });
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
          # TODO: this should be `run` and point to an executable which should
          # set everything up for the user
          file = mkOption {
            type = types.str;
            default = "nixpkgs/home.nix";
            description = "location of home-manager configuration file within configuration repository";
          };
        };
      });
    };
  };
  config = {
    nixpkgs.overlays = [ home-manager-overlay ];

    # run get user configuration on startup
    systemd.services = mkIf (users != {}) (mapAttrs' (user: cfg:
      nameValuePair ("home-config-${utils.escapeSystemdPath user}") {
        description = "initial home-manager configuration for ${user}";
        wantedBy = [ "multi-user.target" ];
        # do not allow login before setup is finished, it would produce
        # inconsistent results
        # TODO: in graphical setups `display-manager.service` will
        # start in parallel and present a login screen although it
        # is not even usable. if `services.xserver.enable == true`
        # add `display-manager.service` to `before`.
        before = [ "systemd-user-sessions.service" ];
        after = [ "nix-daemon.socket" "network-online.target" ];
        requires = [ "nix-daemon.socket" "network-online.target" ];
        serviceConfig = {
          User = user;
          Type = "oneshot";
          SyslogIdentifier = "home-config-${user}";
          ExecStart = let
            git = "${pkgs.git}/bin/git";
            home-manager = "${home-manager-for-user cfg}/bin/home-manager";
          in
            writeScript "home-config-${user}"
            ''
              #! ${stdenv.shell} -el
              mkdir -p $HOME/${cfg.path}
              cd $HOME/${cfg.path}
              ${git} init
              ${git} remote add origin ${cfg.repo} \
                || { echo "keep existing repository state"; exit 0; }
              ${git} fetch
              ${git} checkout ${cfg.branch} --force
              ${home-manager} switch
            '';
        };
      }
    ) users);

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

    # use `home-manager` with correct path per user
    users.users = mkIf (users != {}) (mapAttrs' (user: cfg:
    nameValuePair user {
      packages = [ (home-manager-for-user cfg) ];
    }) users);
  };
}
