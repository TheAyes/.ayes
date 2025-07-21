#!/run/current-system/sw/bin/bash
nixos-rebuild list-generations --json |
 jq -r '.[0] | "['"$(hostname)"' gen.\(.generation)] Version \(.nixosVersion) - \(if .kernelVersion == "Unknown" then "'"$(uname -r)"'" else .kernelVersion end)\n\nBuilt: \(.date)"'

