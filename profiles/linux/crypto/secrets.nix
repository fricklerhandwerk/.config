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
      Requires = [ "mount-secrets.service" ];
      After = [ "mount-secrets.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      Environment = concatStringsSep " " [
       "PATH=${lib.makeBinPath [ coreutils ]}"
      ];
      ExecStart = let script = writeShellScriptBin "import-ssh-keys" ''
          set -e
          for f in "${mount}"/ssh/*
          do
            install -D -m600 "$f" $HOME/.ssh
          done
        ''; in "${script}/bin/import-ssh-keys";
    };
  };

  systemd.user.services.import-gpg-keys = {
    Unit = {
      Description = "Import GPG keys";
      Requires = [ "mount-secrets.service" ];
      After = [ "mount-secrets.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "oneshot";
      Environment = concatStringsSep " " [
       "PATH=${lib.makeBinPath [ gnupg ]}"
       "GNUPGHOME=${env.GNUPGHOME}"
      ];
      ExecStart = let script = writeShellScriptBin "import-gpg-keys" ''
          set -e
          for key in "${mount}"/gpg/*
          do
            gpg --batch --import "$key"
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
