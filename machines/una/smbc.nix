{ pkgs, lib, ... }:
{
  # daily systemd serivce to scrape comics and push updates to master
  systemd.user.services.smbc-update =
  let
    smbc = builtins.fetchGit {
      url = "ssh://git@github.com/fricklerhandwerk/smbc";
      ref = "master";
    };
    env = (import "${smbc}/scripts" { inherit pkgs; });
  in {
    Unit = { Description =  "update SMBC comics archive"; };
    Service = {
      Environment = [
        "GIT_SSH_COMMAND='ssh -i $HOME/.ssh/github -o IdentitiesOnly=yes'"
      ];
      # assumes this repository is already present here:
      WorkingDirectory = "%h/smbc";
      ExecStart = "${env}/bin/push-update";
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
