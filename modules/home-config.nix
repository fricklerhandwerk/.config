{ config, lib, pkgs, utils,  ... }:
with lib;
with builtins;
let
  users = config.home-config.users;
  home-manager-overlay = self: super: {
    home-manager = let
      src = fetchTarball {
        url = https://github.com/rycee/home-manager/archive/release-18.09.tar.gz;
        sha256 = "0r1mv2ynavk5jm48j0w7gpvqzlb3d8588bq5hyj4m69jwgli8m30";
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
