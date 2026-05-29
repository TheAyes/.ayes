{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.autostart;

  mkService = name: app: {
    Unit = {
      Description = app.description;
      After = [ "graphical-session.target" ] ++ lib.optional app.requiresNetwork "network-online.target";
      Wants = lib.optional app.requiresNetwork "network-online.target";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = app.command;
      Restart = "on-failure";
      RestartSec = app.restartSec;
    } // lib.optionalAttrs app.requiresNetwork {
      ExecStartPre = "${pkgs.networkmanager}/bin/nm-online -q -t 60";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
in
{
  options.services.autostart = {
    enable = lib.mkEnableOption "the autostart service";

    apps = lib.mkOption {
      default = { };
      description = "Applications to start with the graphical session.";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              description = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Human-readable description of the service.";
              };
              command = lib.mkOption {
                type = lib.types.str;
                description = "Command to execute on session start.";
              };
              requiresNetwork = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Wait for `network-online.target` and `nm-online` before starting.";
              };
              restartSec = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 5;
                description = "Seconds to wait before restarting on failure.";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = lib.mapAttrs mkService cfg.apps;
  };
}
