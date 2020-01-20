{ config, lib, pkgs, ... }:
with builtins;
with pkgs;
let
  env = config.home.sessionVariables;
  partition = "usb-Intenso_Rainbow_Line_6E145441-0:0-part1";
  label = "SECRETS";
  device-id = "/dev/disk/by-id/${partition}";
  mount = "/run/media/${config.home.username}/${label}";
in
{
  # TODO: wrap in regular service for now. `home-manager` does not support
  # `mount` or `automount`
  # TODO: use `pkgs.writeShellScript` as soon as available in used version of `nixpkgs`
  systemd.user.services.mount-secrets = {
    Unit = {
      Description = "Mount secrets storage";
      ConditionPathExists = "${device-id}";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${udiskie}/bin/udiskie-mount ${device-id}";
    };
  };

  systemd.user.services.import-ssh-keys = {
    Unit = {
      Description = "Import SSH keys";
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
      Environment = concatStringsSep " " [
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
          for f in ${concatStringsSep " " (map (f: "${mount}/ssh/${f}*") keys)}
          do
            install -D -m600 "$f" $HOME/.ssh
          done
        ''; in "${script}/bin/import-ssh-keys";
    };
  };

  systemd.user.services.import-gpg-keys = {
    Unit = {
      Description = "Import GPG keys";
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
      Environment = concatStringsSep " " [
       "PATH=${lib.makeBinPath [ gnupg ]}"
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
            gpg --batch --import ${mount}/gpg/$key.asc
          done
        ''; in "${script}/bin/import-gpg-keys";
    };
  };

  systemd.user.services.fetch-password-store = {
    Unit = {
      Description = "Fetch password store";
      # XXX: the directory itself should be enough if we could detect failures
      # and clean up properly, but `git-remote-gcrypt` swallows the error that
      # might happen when internally re-fetching the repository, for reasons
      # I do not understand. therefore check against an artifact of successful
      # decryption of the repository.
      ConditionPathExists = "!${env.PASSWORD_STORE_DIR}/.gpg-id";
      Requires = [ "import-gpg-keys.service" ];
      After = [ "import-gpg-keys.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      Environment = concatStringsSep " " [
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
          if test $SERVICE_RESULT != "success"
          then
            rm -rf $password_store;
          fi
        ''; in "${script}/bin/clean-password-store";
    };
  };
}
