{ pkgs, ... }:
{
  systemd.user.services.steam = {
    Unit = {
      Description = "Steam";
      After = [
        "graphical-session.target"
        "network-online.target"
      ];
      Wants = [ "network-online.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.networkmanager}/bin/nm-online -q -t 60";
      ExecStart = "/run/current-system/sw/bin/steam -silent";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
