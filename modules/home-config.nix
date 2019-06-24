{ config, lib, pkgs, utils,  ... }:
with lib;
let
  # TODO: extend `config.users.users` to accomodate the new fields.
  users = config.home-config.users;
  home-manager-overlay = self: super: {
    home-manager = let
      src = builtins.fetchGit {
        name = "home-manager-${config.system.stateVersion}";
        url = https://github.com/rycee/home-manager;
        ref = "release-${config.system.stateVersion}";
      };
    in (import src {inherit pkgs;}).home-manager;
  };
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
          path = mkOption {
            type = types.str;
            default = ".config";
            description = "clone path for configuration repository, relative to user's $HOME"; };
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
    systemd.services = mkIf (users != {}) (mapAttrs' (username: cfg:
      nameValuePair ("home-config-${utils.escapeSystemdPath username}") {
        description = "initial home-manager configuration for ${username}";
        wantedBy = [ "multi-user.target" ];
        wants = [ "nix-daemon.socket" ];
        after = [ "nix-daemon.socket" ];
        serviceConfig = with pkgs; {
          User = username;
          Type = "oneshot";
          SyslogIdentifier = "home-config-${username}";
          ExecStart = writeScript "home-config-${username}"
          ''
            #! ${stdenv.shell} -el
            if [[ ! -d $HOME/${cfg.path} ]]; then
              cd $HOME
              ${git}/bin/git clone ${cfg.repo} ${cfg.path}
              ${home-manager}/bin/home-manager \
              -f ${cfg.path}/${cfg.file} \
              switch
            fi
          '';
        };
      }
    ) users);

    # use `home-manager` with correct path per user
    users.users = with pkgs; mkIf (users != {}) (mapAttrs' (username: cfg:
    nameValuePair username {
      packages = [
        (symlinkJoin {
          name = "home-manager";
          paths = [
            (writeShellScriptBin "home-manager" ''
              exec ${home-manager}/bin/home-manager -f $HOME/${cfg.path}/${cfg.file} $@
             '')
            home-manager
          ];
        })
      ];
    }) users);
  };
}
