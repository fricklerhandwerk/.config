path: {config, lib, pkgs, ...}:
{
  imports = [
    # bring actual configuration into scope
    import nixpkgs/home.nix {inherit config lib pkgs;}
  ];
  config.systemd.user.services.home-config = {
    Unit = {
      Description = "make sure home-manager configuration is in $HOME on login";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = let script = pkgs.writeScriptBin "copy-config"
        ''
          #!${pkgs.stdenv.shell}
          ${pkgs.rsync}/bin/rsync -a ${path}/ $HOME/.config
          echo "foo" > $HOME/test
        '';
      in "${script}/bin/copy-config";
    };
  };
}
