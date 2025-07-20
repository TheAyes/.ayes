#!/run/current-system/sw/bin/bash
nixos-rebuild list-generations --json | jq -r '.[0] | "['"$(hostname)"' gen.\(.generation)] Version \(.nixosVersion) - \(.kernelVersion)\n\nBuilt: \(.date)"'