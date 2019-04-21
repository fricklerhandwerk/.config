{ pkgs, ... }:
with builtins;
with lib;
with import <home-manager/modules/lib/dag.nix> {inherit lib;};
let secrets = "$HOME/.config/secrets"; in
{
  home.packages = with pkgs; [
    dmenu
    qutebrowser
    pass
    gnupg
  ];
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Util.EZConfig(additionalKeys)
        main = xmonad $ defaultConfig
          { modMask = mod4Mask
	  , terminal = "uxterm -fa 'Ubuntu Mono' -ls -xrm 'UXTerm*selectToClipboard: true'"
          , borderWidth = 3
	  , focusFollowsMouse = False
          } `additionalKeys`
          [ ((mod4Mask, xK_Return), spawn "dmenu_run")
          ]
      '';
    };
  };
  services.gpg-agent.enable = true;
  # get secrets in place
  home.activation.copySecrets = dagEntryAfter ["writeBoundary"] ''
    if [[ ! -d ${secrets} ]]; then
      mnt=$(lsblk -no MOUNTPOINT $(blkid -U 5FA0-D2A4))
      if [[ -z $mnt ]]; then
        echo "secret storage not mounted"
        exit 1
      fi
      cp -R $mnt/secrets ${secrets}
      chmod -RT u=rwx,g=,o= ${secrets}
      fi
  '';
  home.activation.sshKeys = dagEntryAfter ["copySecrets"] ''
    install -D -m600 ${secrets}/ssh/id_rsa_github $HOME/.ssh/id_rsa_github
  '';
  home.activation.passwords = dagEntryAfter ["copySecrets"] ''
    cp -RT ${secrets}/password-store $HOME/.password-store
    chmod -R u=rwx,g=,o= $HOME/.password-store
  '';
}
