{ pkgs, ... }:
{
  systemd.timers."upgrade-server" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."upgrade-server" = {
    description = "Pull, upgrade, push, and reboot";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/etc/nixos";
      ExecStart = pkgs.writeShellScript "upgrade-server" ''
        set -e
        git pull
        /etc/nixos/scripts/rebuild.sh boot --update --headless
        git push
        systemctl reboot
      '';
    };
  };
}
