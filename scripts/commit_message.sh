#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq

TARGET_HOST="${1:-}"

if [ -n "$TARGET_HOST" ]; then
	EXEC=(ssh "$TARGET_HOST")
else
	EXEC=()
fi

REMOTE_HOSTNAME=$("${EXEC[@]}" hostname)
REMOTE_KERNEL=$("${EXEC[@]}" uname -r)

"${EXEC[@]}" nixos-rebuild list-generations --json |
 jq -r --arg host "$REMOTE_HOSTNAME" --arg kernel "$REMOTE_KERNEL" \
   '.[0] | "[\($host) gen.\(.generation)] Version \(.nixosVersion) - \(if .kernelVersion == "Unknown" then $kernel else .kernelVersion end)\n\nBuilt: \(.date)"'
