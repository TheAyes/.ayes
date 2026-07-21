{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.mcWorldSync;

  endpointType = lib.types.submodule {
    options = {
      host = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          SSH destination for this endpoint (e.g. "ayes@io"), or null when the
          server's data lives on the same machine the command is run from.
        '';
      };
      dataDir = lib.mkOption {
        type = lib.types.str;
        example = "/srv/minecraft/prominence";
        description = "nix-minecraft data directory for this server on its host.";
      };
    };
  };

  # Baked-in runtime config the script reads via jq.
  configJson = pkgs.writeText "mc-world-sync.json" (
    builtins.toJSON {
      inherit (cfg) worldPaths contentPaths servers;
    }
  );

  syncScript = pkgs.writeShellApplication {
    name = "mc-world-sync";
    # SC2029: remote commands are intentionally assembled and expanded client-side.
    excludeShellChecks = [ "SC2029" ];
    runtimeInputs = with pkgs; [
      rsync
      openssh
      gnutar
      zstd
      jq
      coreutils
    ];
    text = ''
      export MC_WORLD_SYNC_CONFIG=${configJson}
    ''
    + builtins.readFile ./mc-world-sync.sh;
  };

  mkWrapper = name: sub: pkgs.writeShellScriptBin name ''
    exec ${syncScript}/bin/mc-world-sync ${sub} "$@"
  '';
in
{
  options.programs.mcWorldSync = {
    enable = lib.mkEnableOption "the Minecraft live⇄dev world/content sync commands";

    worldPaths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "world"
        "world_nether"
        "world_the_end"
      ];
      description = ''
        World save directories, relative to a server's data dir. Copied on pull
        only; never on push, so a live world can never be overwritten.
      '';
    };

    contentPaths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "mods"
        "config"
        "defaultconfigs"
        "kubejs"
        "scripts"
      ];
      description = ''
        Mod/config directories, relative to a server's data dir. Copied on both
        pull and push. Server-managed files (server.properties, whitelist.json,
        ops.json, eula.txt) are intentionally excluded so each server keeps its
        own port/whitelist/ops.
      '';
    };

    servers = lib.mkOption {
      default = { };
      description = ''
        Live⇄dev server pairs, keyed by the live server name. The dev server is
        assumed to be named "<name>-dev" (systemd unit minecraft-server-<name>-dev).
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            live = lib.mkOption {
              type = endpointType;
              description = "The live server endpoint.";
            };
            dev = lib.mkOption {
              type = endpointType;
              description = "The dev server endpoint.";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      syncScript
      (mkWrapper "mc-world-pull" "pull")
      (mkWrapper "mc-world-push" "push")
    ];
  };
}
