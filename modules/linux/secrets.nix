{ config, lib, pkgs, ... }:
let
  # TODO: use WWN if possible (probably needs a more modern USB stick)
  device-id = "5FA0-D2A4";
  secrets = "${config.xdg.configHome}/secrets";
  env = config.home.sessionVariables;
in
with config.lib;
with pkgs;
{
  home.sessionVariables = {
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };
  home.packages = [
    gnupg
  ];
  services.gpg-agent.enable = true;

  # TODO: wrap in regular service for now. `home-manager` does not support
  # `mount` or `automount`
  # TODO: specify mount location for use in other units
  # TODO: use `pkgs.writeShellScript` as soon as available in used version of `nixpkgs`
  home.activation.copySecrets = dag.entryAfter ["writeBoundary"] ''
    if [[ ! -d ${secrets} ]]; then
      dev=$(blkid -U ${device-id})
      if [[ -z $dev ]]; then
        echo "secret storage not attached"
        exit 1
      fi
      mnt=$(lsblk -no MOUNTPOINT $dev)
      if [[ -z $mnt ]]; then
        # TODO: just use `blkid` again...
        # "mounted <DBus device> on <mountpoint>"
        msg=$(${udiskie}/bin/udiskie-mount $dev)
        mnt=$(echo $msg | rev | cut -d' ' -f1 | rev)
      fi
      if [[ ! -d $(realpath $mnt) ]]; then
        echo "could not mount secret storage"
        exit 1
      fi
      cp -RT $mnt/secrets ${secrets}
      chmod -R u=rwx,g=,o= ${secrets}
      umount $mnt
    fi
  '';

  systemd.user.services.import-ssh-keys = {
    Unit = {
      Description = "Import SSH keys";
      Before = [ "default.target" ];
      Wants = [ "mount-secrets.service" ];
      After = [ "mount-secrets.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = let
      keys = [
        "github"
        "una"
      ];
    in {
      Type = "oneshot";
      Environment = builtins.concatStringsSep " " [
       "PATH=${lib.makeBinPath [ coreutils ]}"
      ];
      ExecCondition = let script = writeShellScriptBin "check-ssh-keys" ''
          for f in ${concatStringsSep " " (map (f: "$HOME/.ssh/${f}*") keys)}
          do
            if ! test -f "$f"
            then
              exit 0
            fi
          done
          exit 1
        ''; in "${script}/bin/check-ssh-keys";
      ExecStart = let script = writeShellScriptBin "import-ssh-keys" ''
          set -e
          for f in ${concatStringsSep " " (map (f: "${secrets}/ssh/${f}*") keys)}
          do
            install -D -m600 "$f" $HOME/.ssh/
          done
        ''; in "${script}/bin/import-ssh-keys";
    };
  };

  systemd.user.services.import-gpg-keys = {
    Unit = {
      Description = "Import GPG keys";
      Before = [ "default.target" ];
      Wants = [ "mount-secrets.service" ];
      After = [ "mount-secrets.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = let
      keys = [
        "A36D00C0EFF2C3E1E0603429EA79BFF41C157B3F"
      ];
    in {
      Type = "oneshot";
      Environment = builtins.concatStringsSep " " [
       "PATH=${lib.makeBinPath [ gpg ]}"
       "GNUPGHOME=${env.GNUPGHOME}"
      ];
      ExecCondition = let script = writeShellScriptBin "check-gpg-keys" ''
          for key in ${concatStringsSep " " keys}
          do
            if ! gpg --list-secret-keys $key
            then
              exit 0
            fi
          done
          exit 1
        ''; in "${script}/bin/check-gpg-keys";
      ExecStart = let script = writeShellScriptBin "import-gpg-keys" ''
          set -e
          for key in ${concatStringsSep " " keys}
          do
            gpg --batch --import ${secrets}/$key.asc
          done
        ''; in "${script}/bin/import-gpg-keys";
    };
  };

  systemd.user.services.fetch-password-store = {
    Unit = {
      Description = "Fetch password store";
      Before = [ "default.target" ];
      # XXX: the directory itself should be enough if we could detect failures
      # and clean up properly, but `git-remote-gcrypt` swallows the error that
      # might happen when internally re-fetching the repository, for reasons
      # I do not understand. therefore check against an artifact of successful
      # decryption of the repository..
      ConditionPathExists = "!${env.PASSWORD_STORE_DIR}/.gpg-id";
      Requires = [ "import-gpg-keys.service" ];
      After = [ "import-gpg-keys.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      Environment = builtins.concatStringsSep " " [
       "PATH=${lib.makeBinPath [ git gitAndTools.gitRemoteGcrypt coreutils ]}"
       "GNUPGHOME=${env.GNUPGHOME}"
       "password_store=${env.PASSWORD_STORE_DIR}"
      ];
      ExecStart = let script = writeShellScriptBin "fetch-password-store" ''
          mkdir -m u=rwx,g=,o= -p $password_store
          # WARNING: this may still succeed even if `git-remote-gcrypt` fails
          # to "find" the repository. see commit history for details.
          git clone gcrypt::https://github.com/fricklerhandwerk/password-store $password_store
          cd $password_store
          git remote set-url origin --push gcrypt::git@github.com:fricklerhandwerk/password-store
        ''; in "${script}/bin/fetch-password-store";
      ExecStopPost = let script = writeShellScriptBin "clean-password-store" ''
          test $SERVICE_RESULT != "success"
          then
            rm -rf $password_store;
          fi
        ''; in "${script}/bin/clean-password-store";
    };
  };
}
