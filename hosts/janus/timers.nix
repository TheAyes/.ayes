{ pkgs, config, ... }:
let
  matrixRoomId = "!ezRIEmZMsaRZTaGMBZ:convene.chat";
  matrixHomeserver = "http://localhost:8008";
  tokenPath = config.sops.secrets."matrix/bot_access_token".path;
in
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
    path = with pkgs; [ git nh openssh nix ];
    environment.HOME = "/home/ayes";
    serviceConfig = {
      Type = "oneshot";
      User = "ayes";
      WorkingDirectory = "/etc/nixos";
      ExecStart = pkgs.writeShellScript "upgrade-server" ''
        set -e

        send_alert() {
          local message="$1"
          local token
          token=$(cat ${tokenPath})
          ${pkgs.curl}/bin/curl -s -X POST \
            "${matrixHomeserver}/_matrix/client/v3/rooms/${matrixRoomId}/send/m.room.message" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "{\"msgtype\":\"m.text\",\"body\":\"$message\"}"
        }

        if ! git fetch || ! git reset --hard origin/main; then
          send_alert "⚠️ Janus upgrade failed: git fetch/reset failed"
          exit 1
        fi

        if ! nh os boot . --update; then
          send_alert "⚠️ Janus upgrade failed: rebuild failed"
          exit 1
        fi

        if ! git diff --quiet flake.lock; then
          git add flake.lock
          git commit -m "[janus] Auto-update flake.lock"
        fi

        if ! git push; then
          send_alert "⚠️ Janus upgrade failed: git push failed"
          exit 1
        fi

        send_alert "✅ Janus upgrade successful: rebooting..."
        sudo systemctl reboot
      '';
    };
  };
}
