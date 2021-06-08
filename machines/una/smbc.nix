{ pkgs, lib, ... }:
{
  # daily systemd serivce to scrape comics and push updates to master
  systemd.user.services.smbc-update =
  let
    smbc = builtins.fetchGit {
      url = "ssh://git@github.com/fricklerhandwerk/smbc";
      ref = "master";
    };
    pyEnv = (import "${smbc}").pyEnv;
    push-update = pkgs.writeShellScriptBin "push-update" ''
      export PATH=${with pkgs; lib.makeBinPath [ pyEnv git openssh coreutils ]}:$PATH
      set -e
      today=$(date --rfc-3339 date)
      git checkout master
      git pull origin master
      script/scrape.py
      git add source/comics
      git commit -m "automatic update"
      git push origin master
      script/verify.py
      script/download.py
    '';
  in {
    Unit = { Description =  "update SMBC comics archive"; };
    Service = {
      Environment = [
        "GIT_SSH_COMMAND='ssh -i $HOME/.ssh/github -o IdentitiesOnly=yes'"
      ];
      # assumes this repository is already present here:
      WorkingDirectory = "%h/smbc";
      ExecStart = "${push-update}/bin/push-update";
    };
  };
  systemd.user.timers.smbc-update = {
    Unit = { Description = "daily update of SMBC comics archive"; };
    Timer = {
      Unit = "smbc-update.service";
      OnCalendar = "daily";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
