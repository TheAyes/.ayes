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
    path = with pkgs; [ git nixos-rebuild openssh nix jq bash coreutils hostname ];
    environment = {
      HOME = "/home/ayes";
      GIT_SSH_COMMAND = "ssh -i /home/ayes/.ssh/id_ed25519 -o IdentitiesOnly=yes";
    };
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/etc/nixos";
      ExecStart = pkgs.writeShellScript "upgrade-server" ''
        set -e

        send_alert() {
          local message="$1"
          local timestamp
          timestamp=$(date '+%Y-%m-%d %H:%M:%S %Z')
          local token
          token=$(cat ${tokenPath})
          jq -nc --arg body "[$timestamp]"$'\n'"$message" '{msgtype:"m.text", body:$body}' \
            | ${pkgs.curl}/bin/curl -s -X POST \
                "${matrixHomeserver}/_matrix/client/v3/rooms/${matrixRoomId}/send/m.room.message" \
                -H "Authorization: Bearer $token" \
                -H "Content-Type: application/json" \
                --data-binary @-
        }

        fail() {
          local stage="$1"
          send_alert "⚠️ Janus upgrade failed: $stage"$'\n\n'"$(journalctl -u upgrade-server.service -n 20 --no-pager)"
          exit 1
        }

        if ! git fetch || ! git reset --hard origin/main; then
          fail "git fetch/reset"
        fi

        if ! nix flake update || ! nixos-rebuild boot --flake .#janus; then
          fail "rebuild"
        fi

        if ! git diff --quiet flake.lock; then
          git add flake.lock
          git commit -m "$(bash scripts/commit_message.sh)"
        fi

        if ! git push; then
          fail "git push"
        fi

        new=$(readlink -f /nix/var/nix/profiles/system)
        current=$(readlink -f /run/current-system)
        if [ "$new" = "$current" ]; then
          send_alert "✅ Janus upgrade: no system changes, skipping reboot"
          exit 0
        fi

        send_alert "✅ Janus upgrade successful: rebooting..."
        systemctl reboot
      '';
    };
  };
}
