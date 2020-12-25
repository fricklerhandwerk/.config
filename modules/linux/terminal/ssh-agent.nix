{ config, pkgs, ... }:
{
  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "SSH Agent";
    };
    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent.socket";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${SSH_AUTH_SOCK:-$XDG_RUNTIME_DIR/ssh-agent.socket}";
  };
}
