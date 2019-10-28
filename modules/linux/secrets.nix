{ config, pkgs, ... }:
let
  # TODO: use WWN if possible (probably needs a more modern USB stick)
  device-id = "5FA0-D2A4";
  secrets = "${config.xdg.configHome}/secrets";
  env = config.home.sessionVariables;
in
with config.lib;
{
  home.sessionVariables = {
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };
  home.packages = with pkgs; [
    gnupg
  ];
  services.gpg-agent.enable = true;

  # TODO: maybe all of these should be user services instead, which depend on
  # their target files not existing. right now there is this weird indirection
  # via a de-facto temporary file. the problem with user services is just that
  # their failure won't fail a build, and it is a bit more work to retrigger
  # them when needed. on the other hand presence of secrets should not
  # determine build success, they are really just state. the first boot will
  # simply fail if something goes wrong and there is little one can do except
  # plugging in the external storage if it was forgotten.

  # get secrets in place
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
        msg=$(${pkgs.udiskie}/bin/udiskie-mount $dev)
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
  home.activation.gpgKeys = dag.entryAfter ["copySecrets"] ''
    mkdir -p ${env.GNUPGHOME}
    ${pkgs.gnupg}/bin/gpg --batch --import ${secrets}/gpg.asc
  '';
  home.activation.sshKeys = dag.entryAfter ["copySecrets"] ''
    install -D -m600 ${secrets}/ssh/github* $HOME/.ssh/
    install -D -m600 ${secrets}/ssh/una* $HOME/.ssh/
  '';
  # TODO: fetch `.password-store` from a private git repo. do this in a user
  # service, as it will prompt for GPG key password, for which we need to be
  # logged in - home environment build happens before first login.
  home.activation.passwords = dag.entryAfter ["copySecrets"] ''
    cp -RT ${secrets}/password-store ${env.PASSWORD_STORE_DIR}
    chmod -R u=rwx,g=,o= ${env.PASSWORD_STORE_DIR}
  '';
}
