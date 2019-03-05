path: {config, lib, pkgs, ...}:
# bring actual configuration into scope
with import nixpkgs/home.nix {inherit config lib pkgs;};
{
  config.systemd.user.services.home-config = {
    Unit = {
      Description = "make sure home-manager configuration is in $HOME on login";
      After = [ "multi-user.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = let script = pkgs.writeScriptBin "copy-config"
        ''
          #!${pkgs.stdenv.shell}
          ${pkgs.rsync}/bin/rsync -a ${path}/ $HOME/.config
          chmod -R u+wx $HOME/.config
        '';
      in "${script}/bin/copy-config";
    };
  };
}
