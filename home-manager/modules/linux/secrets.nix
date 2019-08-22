{ pkgs, lib, ... }:
with import <home-manager/modules/lib/dag.nix> {inherit lib;};
let
  device-id = "5FA0-D2A4";
  secrets = "$HOME/.config/secrets";
in
{
  home.packages = with pkgs; [
    pass
    gnupg
  ];
  services.gpg-agent.enable = true;

  # get secrets in place
  home.activation.copySecrets = dagEntryAfter ["writeBoundary"] ''
    if [[ ! -d ${secrets} ]]; then
      dev=$(blkid -U ${device-id})
      if [[ -z $dev ]]; then
        echo "secret storage not attached"
        exit 1
      fi
      mnt=$(lsblk -no MOUNTPOINT $dev)
      if [[ -z $mnt ]]; then
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
  home.activation.gpgKeys = dagEntryAfter ["copySecrets"] ''
    ${pkgs.gnupg}/bin/gpg --import ${secrets}/gpg/AE02F55D.asc
  '';
  home.activation.sshKeys = dagEntryAfter ["copySecrets"] ''
    install -D -m600 ${secrets}/ssh/id_rsa_github $HOME/.ssh/id_rsa_github
  '';
  # TODO: fetch `.password-store` from a private git repo to be able to keep it
  # up to date. PGP and SSH keys (assuming we are not using gpg-agent for SSH
  # authentication) should be the only secrets to copy. not sure yet whether it
  # is a good idea to have so many repositories, but so far machines, user
  # config and secrets are three independent concepts where it makes sense to
  # keep separate histories for.
  home.activation.passwords = dagEntryAfter ["copySecrets"] ''
    cp -RT ${secrets}/password-store $HOME/.password-store
    chmod -R u=rwx,g=,o= $HOME/.password-store
  '';
}
